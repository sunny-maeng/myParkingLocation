//
//  DrawingView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/26.
//

import UIKit

final class DrawingView: UIView {

    private var lastPoint: CGPoint?
    private let lineSize: CGFloat = 10
    private let lineColor: CGColor = UIColor.black.cgColor

    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Clear", for: .normal)     // 버튼 지우개 모양으로 바꾸기
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(self.touchedUpClearButton(), for: .touchUpInside)

        return button
    }()

    private let drawingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var drawingImageViewDefaultImage: UIImage?

    convenience init(defaultImage: String) {
        self.init(frame: .zero)
        self.setupView()
        setupImageInDrawingView(imageName: defaultImage)
    }
}

// MARK: - Draw using Touch
extension DrawingView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if drawingImageView.image == drawingImageViewDefaultImage {
            removeImage()
        }

        lastPoint = (touch as UITouch).location(in: drawingImageView)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(drawingImageView.frame.size)

        guard let touch = touches.first,
              let context = UIGraphicsGetCurrentContext() else { return }

        let currentPoint = touch.location(in: drawingImageView)
        setupContext(on: context)
        context.move(to: CGPoint(x: lastPoint?.x ?? .zero, y: lastPoint?.y ?? .zero))
        context.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
        context.strokePath()

        drawingImageView.image?.draw(in: CGRect(x: .zero, y: .zero,
                                                width: drawingImageView.frame.size.width,
                                                height: drawingImageView.frame.size.height))
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        lastPoint = currentPoint
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(drawingImageView.frame.size)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        setupContext(on: context)
        context.move(to: CGPoint(x: lastPoint?.x ?? .zero, y: lastPoint?.y ?? .zero))
        context.addLine(to: CGPoint(x: lastPoint?.x ?? .zero, y: lastPoint?.y ?? .zero))
        context.strokePath()

        drawingImageView.image?.draw(in: CGRect(x: .zero, y: .zero,
                                                width: drawingImageView.frame.size.width,
                                                height: drawingImageView.frame.size.height))
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    private func setupContext(on context: CGContext) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(lineColor)
        context.setLineCap(.round)
        context.setLineWidth(lineSize)
    }
}

// MARK: - setup image in DrawingImageView
extension DrawingView {

    private func setupImageInDrawingView(imageName: String) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.writingViewDefaultImagePointSize,
                                                      weight: .medium)
        drawingImageViewDefaultImage = UIImage(systemName: imageName, withConfiguration: imageConfig)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)

        drawingImageView.image = drawingImageViewDefaultImage
    }
}

// MARK: - clearAction
extension DrawingView {

    private func touchedUpClearButton() -> UIAction {
        return UIAction { _ in self.removeImage() }
    }

    private func removeImage() {
        drawingImageView.image = nil
    }
}

// MARK: - Hierarchy & layout
extension DrawingView {

    private func setupView() {
        configureHierarchy()
        configureLayout()
        configureBorder()

        self.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureBorder() {
        self.layer.cornerRadius = Constant.cornerRadius
        self.layer.borderWidth = Constant.borderWidth
        self.layer.borderColor = UIColor.mainBlue.cgColor
    }

    private func configureHierarchy() {
        [clearButton, drawingImageView].forEach { view in
            self.addSubview(view)
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: self.topAnchor, constant: Constant.stackSpacing),
            clearButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.stackSpacing),

            drawingImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            drawingImageView.topAnchor.constraint(equalTo: self.topAnchor),
            drawingImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            drawingImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
