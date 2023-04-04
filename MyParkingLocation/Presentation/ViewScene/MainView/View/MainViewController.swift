//
//  ViewController.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/02/24.
//

import UIKit

class MainViewController: UIViewController {

    let viewModel: MainViewModel = MainViewModel()

    // UI Elements
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
        let button: UIButton = UIButton(imageConfig: imageConfig, image: buttonImage)
        button.addAction(touchedUpPositioningButton(), for: .touchUpInside)

        return button
    }()

    private lazy var cameraButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.buttonImagePointSize, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.cameraButtonImage, withConfiguration: imageConfig)
        let button: UIButton = UIButton(imageConfig: imageConfig, image: buttonImage)
        button.addAction(touchedUpCameraButton(), for: .touchUpInside)

        return button
    }()

    private lazy var drawingButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.buttonImagePointSize, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.pencilButtonImage, withConfiguration: imageConfig)
        let button: UIButton = UIButton(imageConfig: imageConfig, image: buttonImage)
        button.addAction(touchedUpDrawingButton(), for: .touchUpInside)

        return button
    }()

    private lazy var resetButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.buttonImagePointSize - 10, weight: .bold)
        let buttonImage: UIImage? = UIImage(systemName: viewModel.resetButtonImage, withConfiguration: imageConfig)
        let button: UIButton = UIButton(imageConfig: imageConfig, image: buttonImage)
        button.backgroundColor = .systemGray3
        button.addAction(touchedUpResetButton(), for: .touchUpInside)

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
        bindViewModel()
        viewModel.fetchLocation()
    }

    private func bindViewModel() {
        viewModel.error.bind { [weak self] errorDescription in
            guard let self = self,
                  let errorDescription = errorDescription else { return }
            self.showAlert(title: self.viewModel.errorTitle, massage: errorDescription)
        }

        viewModel.savedLocation.bind { [weak self] location in
            guard let self = self else { return }
            guard let location = location else {
                let defaultView = self.viewModel.generateDefaultView()
                self.changeSubviewOfMainView(to: defaultView)
                return
            }

            var mainView: UIView
            switch location.locationType {
            case .coordinate:
                mainView = self.viewModel.generateMapView(location: location)
            case .photo:
                mainView = self.viewModel.generatePhotoView(data: location.locationImage)
            case .drawing:
                mainView = self.viewModel.generateDrawingView(data: location.locationImage)
            }

            self.changeSubviewOfMainView(to: mainView)
            self.makeButtonInactive()
        }
    }
}

// MARK: - ButtonAction
extension MainViewController {

    private func touchedUpPositioningButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else { return }

            let mapView = MapView()
            mapView.delegate = self
            self.changeSubviewOfMainView(to: mapView)
        }
    }

    private func touchedUpCameraButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else { return }

            let photoView = self.viewModel.generatePhotoView()
            self.changeSubviewOfMainView(to: photoView)
            photoView.delegate = self
            photoView.openCamera()
        }
    }

    private func touchedUpDrawingButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else { return }

            let drawingView = self.viewModel.generateDrawingView()
            self.changeSubviewOfMainView(to: drawingView)
        }
    }

    private func touchedUpResetButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else { return }

            let defaultView = self.viewModel.generateDefaultView()
            self.changeSubviewOfMainView(to: defaultView)
            self.viewModel.deleteLocation()
            self.makeButtonActive()
        }
    }

    private func disableButtons(except: UIButton) {
        let allButtons = [positioningButton, cameraButton, drawingButton].filter { $0 != except }
        allButtons.forEach { $0.isEnabled = true }
    }
}

// MARK: - MainView Change
extension MainViewController {

    private func changeSubviewOfMainView(to subView: UIView) {
        self.removeSubViewsOfMainView()
        self.addToMainView(subView: subView)
    }

    private func removeSubViewsOfMainView() {
        mainView.subviews.forEach { $0.removeFromSuperview() }
    }

    private func addToMainView(subView: UIView) {
        mainView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            subView.topAnchor.constraint(equalTo: mainView.topAnchor),
            subView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }
}

// MARK: - Button Enable
extension MainViewController {

    internal func makeButtonInactive() {
        let locationButtons = [positioningButton, cameraButton, drawingButton]
        locationButtons.forEach { $0.isEnabled = false }
        resetButton.backgroundColor = .systemRed
    }

    private func makeButtonActive() {
        let locationButtons = [positioningButton, cameraButton, drawingButton]
        locationButtons.forEach { $0.isEnabled = true }
        resetButton.backgroundColor = .systemGray3
    }
}

// MARK: - MapViewDelegate
extension MainViewController: MapViewDelegate, Alertable {

    func handleError(description: String) {
        showAlert(title: viewModel.errorTitle, massage: description)
    }

    func requestLocationAuthorization() {
        showLocationServiceRequestAlert()
    }
}

// MARK: - PhotoViewDelegate
extension MainViewController: PhotoViewDelegate {

    func requestCameraAuthorization() {
        self.showCameraServiceRequestAlert()
    }

    func openCamera(_ camera: UIImagePickerController) {
        self.present(camera, animated: true)
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
        [positioningButton, cameraButton, drawingButton].forEach { button in
            receiveButtonsStackView.addArrangedSubview(button)
        }

        [mainView, receiveButtonsStackView, resetButton].forEach { view in
            totalStackView.addArrangedSubview(view)
        }

        self.view.addSubview(totalStackView)
    }

    private func configureLayout() {
        [positioningButton, cameraButton, drawingButton].forEach { button in
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
