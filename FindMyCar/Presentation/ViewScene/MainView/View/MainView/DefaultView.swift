//
//  DefaultView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/22.
//

import UIKit

final class DefaultView: UIView {

    let viewModel: DefaultViewModel

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = viewModel.title
        label.font = .preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var defaultImageView: UIImageView = {
        let image = UIImage(systemName: viewModel.image)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.borderWidth = Constant.borderWidth
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

    init(viewModel: DefaultViewModel = DefaultViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        viewModel.deleteLocation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Hierarchy & layout
extension DefaultView {

    private func setupView() {
        configureHierarchy()
        configureLayout()

        self.contentMode = .scaleAspectFit
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
