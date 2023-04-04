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
    let isLoading: Observable<Bool> = Observable(false)
    let isUserDeviceLocationServiceAuthorized: Observable<Bool?> = Observable(nil)
    let progressLabelText: String = "위치를 파악하고 있습니다"
    let defaultImageName: String = "map"
    let parkingAnnotationTitle: String = "CAR"

    private let saveLocationUseCase: SaveLocationUseCase

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        return locationManager
    }()

    init(location: Location? = nil, saveLocationUseCase: SaveLocationUseCase = DefaultSaveLocationUseCase()) {
        self.saveLocationUseCase = saveLocationUseCase
        super.init()

        if let location = location {
            self.setupLocation(location)
        } else {
            locationManager.requestLocation()
        }
    }

    func setupLocation(_ location: Location) {
        self.parkingLocation.value = location
    }

    private func saveLocation(_ location: Location) {
        saveLocationUseCase.save(location: location)
    }
}

// CLLocationManagerDelegate
extension MapViewModel: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            isLoading.value = true
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

        let location = Location(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        isLoading.value = false
        parkingLocation.value = location
        saveLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch (error as? CLError)?.code {
        case .denied:
            locationManagerDidChangeAuthorization(manager)
        case .network:
            self.error.value = "네크워크 연결을 확인해주세요."
        case .locationUnknown:
            self.error.value = "다시 한 번 시도해주세요"
        default:
            self.error.value = "위치 정보를 가져올 수 없습니다."
        }

        isLoading.value = false
    }
}
