//
//  MapViewModel.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/27.
//

import Foundation
import CoreLocation

final class MapViewModel: NSObject {

    let parkingLocation: Observable<Location?> = Observable(nil)
    let error: Observable<String?> = Observable(nil)
    let isUserDeviceLocationServiceAuthorized: Observable<Bool?> = Observable(nil)
    let parkingAnnotationTitle: String = "CAR"

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self

        return locationManager
    }()

    override init() {
        super.init()
        locationManager.requestLocation()
    }
}

// CLLocationManagerDelegate
extension MapViewModel: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            isUserDeviceLocationServiceAuthorized.value = false
        default:
            return
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        parkingLocation.value = Location(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch (error as? CLError)?.code {
        case .denied:
            isUserDeviceLocationServiceAuthorized.value = false
        case .network:
            self.error.value = "네크워크 연결을 확인해주세요."
        case .locationUnknown:
            self.error.value = "다시 한 번 시도해주세요"
        default:
            self.error.value = "위치 정보를 가져올 수 없습니다."
        }
    }
}
