//
//  DrawingView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/26.
//

import UIKit

final class DrawingView: UIView {

    private let viewModel: DrawingViewModel
    private var lastPoint: CGPoint?
    private let lineSize: CGFloat = 10
    private let lineColor: CGColor = UIColor.label.cgColor

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

    private var defaultImage: UIImage?

    init(viewModel: DrawingViewModel = DrawingViewModel(), drawingData: Data? = nil) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupView()
        self.setupNotification()

        if let drawingData = drawingData {
            setupDrawing(drawingData)
        } else {
            setupDefaultImage(imageName: viewModel.defaultImage)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Draw using Touch
extension DrawingView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if drawingImageView.image == defaultImage {
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

// MARK: - setup image
extension DrawingView {

    private func setupDrawing(_ data: Data) {
        let drawing = UIImage(data: data)
        self.drawingImageView.image = drawing
    }

    private func setupDefaultImage(imageName: String) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.writingViewDefaultImagePointSize,
                                                      weight: .medium)
        defaultImage = UIImage(systemName: imageName, withConfiguration: imageConfig)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)

        drawingImageView.image = defaultImage
    }
}

// MARK: - clearAction
extension DrawingView {

    private func touchedUpClearButton() -> UIAction {
        return UIAction { [weak self] _ in self?.removeImage() }
    }

    private func removeImage() {
        drawingImageView.image = nil
    }
}

// MARK: - AutoSave Drawing
extension DrawingView {

    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }

    @objc private func save() {
        guard drawingImageView.image != defaultImage else {
            viewModel.deleteDrawing()
            return
        }
        
        guard let data = drawingImageView.image?.pngData() else { return }
        viewModel.saveDrawing(data)
    }
}

// MARK: - Hierarchy & layout
extension DrawingView {

    private func setupView() {
        configureHierarchy()
        configureLayout()
        configureBorder()
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
