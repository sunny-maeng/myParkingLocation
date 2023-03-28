//
//  MapView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/27.
//

import UIKit

protocol MapViewDelegate: AnyObject where Self: UIViewController {

    func handleError(description: String)
    func requestLocationServiceAlert()
}

final class MapView: UIView {

    var delegate: MapViewDelegate?

    private let viewModel: MapViewModel
    private var mapProvider: MapProvider?
    private var mapView: UIView?

    init(viewModel: MapViewModel = MapViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bindViewModel()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.parkingLocation.bind { [weak self] location in
            guard let location = location else { return }

            let (latitude, longitude) = (location.latitude, location.longitude)
            let delta = 0.001
            self?.generateMap(annotationLatitude: latitude, annotationLongitude: longitude, delta: delta)
        }

        viewModel.error.bind { [weak self] errorDescription in
            guard let errorDescription = errorDescription else { return }
            self?.delegate?.handleError(description: errorDescription)
        }

        viewModel.isUserDeviceLocationServiceAuthorized.bind { [weak self] bool in
            guard let bool = bool, !bool else { return  }
            self?.delegate?.requestLocationServiceAlert()
        }
    }

    private func generateMap(annotationLatitude: Double, annotationLongitude: Double, delta: Double) {
        mapProvider = DefaultMapProvider()
        mapView = mapProvider?.provideMap()
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        setupView()

        mapProvider?.locateMap(latitude: annotationLatitude, longitude: annotationLongitude, delta: delta)
        mapProvider?.setAnnotation(latitude: annotationLatitude, longitude: annotationLongitude, delta: delta,
                                  title: self.viewModel.parkingAnnotationTitle)
    }
}

// Hierarchy & layout
extension MapView {

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
        if let mapView = mapView {
            self.addSubview(mapView)
        }
    }

    private func configureLayout() {
        if let mapView = mapView {
            NSLayoutConstraint.activate([
                mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mapView.topAnchor.constraint(equalTo: self.topAnchor),
                mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
}
