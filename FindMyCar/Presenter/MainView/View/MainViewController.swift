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
        view.layer.cornerRadius = Constant.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var positioningButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.buttonImagePointSize, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.positioningButtonImage,
                                            withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = Constant.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var cameraButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.buttonImagePointSize, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.cameraButtonImage, withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = Constant.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var writeButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.buttonImagePointSize, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.pencilButtonImage, withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = Constant.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var resetButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.buttonImagePointSize - 10, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.refreshButtonImage, withConfiguration: imageConfig)
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = Constant.cornerRadius
        button.addAction(touchedUpRefreshButton(), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let receiveButtonsStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constant.stackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let totalStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Constant.stackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - MainView Change
extension MainViewController {

    private func addToMainView(subView: UIView) {
        mainView.addSubview(subView)

        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            subView.topAnchor.constraint(equalTo: mainView.topAnchor),
            subView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }
}

// MARK: - resetButton
extension MainViewController {

    private func touchedUpRefreshButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else { return }

            let defaultView = DefaultView(title: self.viewModel.defaultTitle, defaultImage: self.viewModel.defaultImage)
            self.addToMainView(subView: defaultView)
        }
    }
}

// MARK: - View hierarchy, layout
extension MainViewController {

    private func setupView() {
        self.view.backgroundColor = .systemBackground
        configureHierarchy()
        configureLayout()
    }

    private func configureHierarchy() {
        [positioningButton, cameraButton, writeButton].forEach { button in
            receiveButtonsStackView.addArrangedSubview(button)
        }

        [mainView, receiveButtonsStackView, resetButton].forEach { view in
            totalStackView.addArrangedSubview(view)
        }

        self.view.addSubview(totalStackView)
    }

    private func configureLayout() {
        [positioningButton, cameraButton, writeButton].forEach { button in
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            mainView.widthAnchor.constraint(equalTo: totalStackView.widthAnchor),
            mainView.heightAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 1.2),
            mainView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            resetButton.heightAnchor.constraint(equalTo: receiveButtonsStackView.heightAnchor, multiplier: 0.5),

            totalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            totalStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            totalStackView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
}
