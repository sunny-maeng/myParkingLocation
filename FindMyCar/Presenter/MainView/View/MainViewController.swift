//
//  ViewController.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/02/24.
//

import UIKit

class MainViewController: UIViewController {

    let viewModel: MainViewModel = MainViewModel()

    private var mainView: UIView = {
        let view: UIView = UIView()
        view.clipsToBounds =  true
        view.layer.cornerRadius = Default.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var positioningButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Default.buttonImagePointSize, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.positioningButtonImage,
                                            withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = Default.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var cameraButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Default.buttonImagePointSize, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.cameraButtonImage, withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = Default.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var pencilButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Default.buttonImagePointSize, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.pencilButtonImage, withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = Default.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var refreshButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Default.buttonImagePointSize - 10, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.refreshButtonImage, withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = Default.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let receiveButtonsStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Default.stackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let totalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Default.stackSpacing
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
        [positioningButton, cameraButton, pencilButton].forEach { button in
            receiveButtonsStackView.addArrangedSubview(button)
        }

        [mainView, receiveButtonsStackView, refreshButton].forEach { view in
            totalStackView.addArrangedSubview(view)
        }

        self.view.addSubview(totalStackView)
    }

    private func configureLayout() {
        [positioningButton, cameraButton, pencilButton].forEach { button in
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            mainView.widthAnchor.constraint(equalTo: totalStackView.widthAnchor),
            mainView.heightAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 1.2),
            mainView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            refreshButton.heightAnchor.constraint(equalTo: receiveButtonsStackView.heightAnchor, multiplier: 0.5),

            totalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            totalStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            totalStackView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
}

extension MainViewController {

    enum Default {

        static let cornerRadius: CGFloat = 10
        static let stackSpacing: CGFloat = 20
        static let buttonImagePointSize: CGFloat = 50
    }
}
