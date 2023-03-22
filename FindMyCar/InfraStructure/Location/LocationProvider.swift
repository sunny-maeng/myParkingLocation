//
//  location.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/22.
//

import Foundation
import CoreLocation

protocol LocationProvider {

    func fetchLocation() -> Location
}

final class DefaultLocationProvider: NSObject {

    private var locationManager: CLLocationManager
    private var lastLocation: Location = Location(latitude: 0, longitude: 0)

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
    }
}

extension DefaultLocationProvider: LocationProvider {

    func fetchLocation() -> Location {
        locationManager.requestLocation()
        return lastLocation
    }
}

extension DefaultLocationProvider: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            return
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }

        lastLocation = Location(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
    }
}
