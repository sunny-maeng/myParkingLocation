//
//  ViewController.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/02/24.
//

import UIKit

class MainViewController: UIViewController {

    private let defaultImageView: UIImageView = {
        let image: UIImage? = UIImage(systemName: "car")
        let imageView: UIImageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds =  true

        return imageView
    }()

    private let positioningButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: "flag", withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let cameraButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: "camera", withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let pencilButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: "pencil", withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let refreshButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: "arrow.clockwise", withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let firstButtonsStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let secondButtonsStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let totalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        self.view.backgroundColor = .systemBackground
        configureHierarchy()
        configureLayout()
    }

    private func configureHierarchy() {
        [positioningButton, cameraButton].forEach { button in
            firstButtonsStackView.addArrangedSubview(button)
        }

        [pencilButton, refreshButton].forEach { button in
            secondButtonsStackView.addArrangedSubview(button)
        }

        [defaultImageView, firstButtonsStackView, secondButtonsStackView].forEach { view in
            totalStackView.addArrangedSubview(view)
        }

        self.view.addSubview(totalStackView)
    }

    private func configureLayout() {
        [positioningButton, cameraButton, pencilButton, refreshButton].forEach { button in
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.5 ).isActive = true
        }

        NSLayoutConstraint.activate([
            totalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            totalStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            defaultImageView.widthAnchor.constraint(equalTo: totalStackView.widthAnchor),
            defaultImageView.heightAnchor.constraint(equalTo: defaultImageView.widthAnchor, multiplier: 1.2),
            defaultImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
