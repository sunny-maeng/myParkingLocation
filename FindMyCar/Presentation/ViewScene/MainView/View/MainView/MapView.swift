//
//  MapView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/27.
//

import UIKit

protocol MapViewDelegate: AnyObject where Self: UIViewController {

    func showError(description: String)
}

final class MapView: UIView {

    var delegate: MapViewDelegate?

    private var mapProvider: MapProvider
    private let viewModel: MapViewModel

    private lazy var mapView: UIView = {
        let map = mapProvider.provideMap()
        map.translatesAutoresizingMaskIntoConstraints = false

        return map
    }()

    init(mapProvider: MapProvider = DefaultMapProvider(), viewModel: MapViewModel = MapViewModel()) {
        self.mapProvider = mapProvider
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.error.bind { [weak self] errorDescription in
            guard let errorDescription = errorDescription else { return }
            self?.delegate?.showError(description: errorDescription)
        }

        viewModel.parkingLocation.bind { [weak self] location in
            guard let location = location, let self = self else { return }

            let latitude = location.latitude
            let longitude = location.longitude
            let delta = 0.001
            let title = self.viewModel.parkingAnnotationTitle
            self.mapProvider.locateMap(latitude: latitude, longitude: longitude, delta: delta)
            self.mapProvider.setAnnotation(latitude: latitude, longitude: longitude, delta: delta, title: title)
        }
    }
}

// Hierarchy & layout
extension MapView {

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
        self.addSubview(mapView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
