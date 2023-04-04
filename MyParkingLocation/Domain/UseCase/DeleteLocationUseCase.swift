//
//  DeleteLocationUseCase.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/31.
//

import Foundation

protocol DeleteLocationUseCase {

    func deleteLocation()
}

final class DefaultDeleteLocationUseCase: DeleteLocationUseCase {

    private let locationRepository: LocationRepository

    init(locationRepository: LocationRepository = DefaultLocationRepository()) {
        self.locationRepository = locationRepository
    }

    func deleteLocation() {
        locationRepository.deleteLocation()
    }
}
