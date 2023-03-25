//
//  WritingView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/26.
//

import UIKit

final class WritingView: UIView {

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

    convenience init(defaultImage: String) {
        self.init(frame: .zero)
        self.setupView()
        setupDrawingViewDefaultImage(imageName: defaultImage)
    }

    private func setupDrawingViewDefaultImage(imageName: String) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.writingViewDefaultImagePointSize,
                                                      weight: .medium)
        let image: UIImage? = UIImage(systemName: imageName, withConfiguration: imageConfig)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)

        drawingImageView.image = image
    }
}

// clearAction
extension WritingView {

    private func touchedUpClearButton() -> UIAction {
        return UIAction { _ in
            self.drawingImageView.image = nil
        }
    }
}

// Hierarchy & layout
extension WritingView {

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
