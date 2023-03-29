//
//  MapView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/27.
//

import UIKit

protocol MapViewDelegate: AnyObject where Self: UIViewController {

    func handleError(description: String)
    func requestLocationAuthorization()
}

final class MapView: UIView {

    var delegate: MapViewDelegate?

    private let viewModel: MapViewModel
    private var mapProvider: MapProvider?
    private var mapView: UIView?
    private let pinMovingDistance: CGFloat = 50

    private lazy var defaultImageView: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.photoViewDefaultImagePointSize,
                                                      weight: .medium)
        let image = UIImage(systemName: viewModel.defaultImageName, withConfiguration: imageConfig)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var loadingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = viewModel.progressLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)

        return label
    }()

    private lazy var pinImageView: UIImageView = {
        let carImage = UIImage.pinImage
        let imageView = UIImageView(image: carImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var carImageView: UIImageView = {
        let carImage = UIImage.carImage
        let imageView = UIImageView(image: carImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var loadingImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init(viewModel: MapViewModel = MapViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bindViewModel()
        setupInitialView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.parkingLocation.bind { [weak self] location in
            guard let location = location else { return }

            let (latitude, longitude) = (location.latitude, location.longitude)
            let delta = 0.001
            self?.generateMap(annotationLatitude: latitude ?? 0, annotationLongitude: longitude ?? 0, delta: delta)
        }

        viewModel.error.bind { [weak self] errorDescription in
            guard let errorDescription = errorDescription else { return }
            self?.delegate?.handleError(description: errorDescription)
        }

        viewModel.isLoading.bind { isLoading in
            guard isLoading else { return }
            self.setupLoadingView()
        }

        viewModel.isUserDeviceLocationServiceAuthorized.bind { [weak self] bool in
            guard let bool = bool, !bool else { return  }
            self?.delegate?.requestLocationAuthorization()
        }
    }

    private func generateMap(annotationLatitude: Double, annotationLongitude: Double, delta: Double) {
        mapProvider = DefaultMapProvider()
        mapView = mapProvider?.provideMap()
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        setupMapView()

        mapProvider?.locateMap(latitude: annotationLatitude, longitude: annotationLongitude, delta: delta)
        mapProvider?.setAnnotation(latitude: annotationLatitude, longitude: annotationLongitude, delta: delta,
                                  title: self.viewModel.parkingAnnotationTitle)
    }
}

// Hierarchy & layout
extension MapView {

    private func setupInitialView() {
        setupDefaultImage()
        configureBorder()
    }

    private func setupDefaultImage() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.addSubview(defaultImageView)

        NSLayoutConstraint.activate([
            defaultImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            defaultImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    private func configureBorder() {
        self.layer.cornerRadius = Constant.cornerRadius
        self.layer.borderWidth = Constant.borderWidth
        self.layer.borderColor = UIColor.mainBlue.cgColor
    }

    private func setupLoadingView() {
        self.subviews.forEach { $0.removeFromSuperview() }
        [loadingLabel, pinImageView, carImageView].forEach { loadingImageStackView.addArrangedSubview($0) }
        self.addSubview(loadingImageStackView)

        loadingImageStackView.setCustomSpacing(pinMovingDistance, after: loadingLabel)
        NSLayoutConstraint.activate([
            loadingImageStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingImageStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        upDownParkingPin()
    }

    private func setupMapView() {
        guard let mapView = mapView else { return }

        self.subviews.forEach { $0.removeFromSuperview() }
        self.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// Animation
extension MapView {

    private func upDownParkingPin() {
        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut, .autoreverse, .repeat]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0) {
                self.pinImageView.center = .init(x: self.pinImageView.center.x,
                                                 y: self.pinImageView.center.y - self.pinMovingDistance / 2)
            }
        }
    }
}
