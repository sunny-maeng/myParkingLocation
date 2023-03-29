//
//  DeleteLocationUseCase.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/29.
//

import Foundation

protocol DelegateLocationUseCase {

    func deleteLocation()
}

final class DefaultDelegateLocationUseCase: DelegateLocationUseCase {

    private let locationRepository: LocationRepository

    init(locationRepository: LocationRepository = DefaultLocationRepository()) {
        self.locationRepository = locationRepository
    }

    func deleteLocation() {
        locationRepository.deleteLocation()
    }
}
