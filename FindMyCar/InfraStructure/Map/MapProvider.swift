//
//  MapProvider.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/27.
//

import MapKit

protocol MapProvider {

    func provideMap() -> UIView
    func locateMap(latitude: Double, longitude: Double, delta: Double)
    func setAnnotation(latitude: Double, longitude: Double, delta: Double, title: String)
}

final class DefaultMapProvider: NSObject {

    private let mapView: MKMapView

    init(mapView: MKMapView = MKMapView()) {
        self.mapView = mapView
        super.init()
        configureMapView()
    }

    private func configureMapView() {
        mapView.showsUserLocation =  true
    }
}

// MARK: - MapProvider
extension DefaultMapProvider: MapProvider {

    func provideMap() -> UIView {
        return mapView
    }

    func locateMap(latitude: Double, longitude: Double, delta span: Double) {
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let region = MKCoordinateRegion(center: location, span: spanValue)
        mapView.setRegion(region, animated: true)
    }

    func setAnnotation(latitude: Double, longitude: Double, delta: Double, title: String) {
        mapView.removeAnnotations(mapView.annotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
}
