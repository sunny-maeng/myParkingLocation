//
//  DefaultView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/22.
//

import UIKit

final class DefaultView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let defaultImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = Constant.cornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let totalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Constant.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    convenience init(title: String, defaultImage: String) {
        self.init(frame: .zero)
        self.setupView()
        self.setupDefaultImage(imageName: defaultImage)
        self.setupTitle(text: title)
    }

    private func setupDefaultImage(imageName: String) {
        defaultImageView.image = UIImage(systemName: imageName)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
    }

    private func setupTitle(text: String) {
        titleLabel.text = text
    }
}

// Hierarchy & layout
extension DefaultView {

    private func setupView() {
        configureHierarchy()
        configureLayout()

        self.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureHierarchy() {
        [titleLabel, defaultImageView].forEach { totalStackView.addArrangedSubview($0) }
        self.addSubview(totalStackView)
    }

    private func configureLayout() {
        titleLabel.setContentHuggingPriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            defaultImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            defaultImageView.heightAnchor.constraint(equalTo: defaultImageView.widthAnchor),

            totalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            totalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
