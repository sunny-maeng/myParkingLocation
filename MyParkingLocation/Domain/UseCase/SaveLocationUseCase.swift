//
//  SaveLocationUseCase.swift
//  FindMyCar
//
//  Created by 맹선아 on 2023/03/29.
//

import Foundation

protocol SaveLocationUseCase {

    func save(location: Location)
}

final class DefaultSaveLocationUseCase: SaveLocationUseCase {

    private let locationRepository: LocationRepository

    init(locationRepository: LocationRepository = DefaultLocationRepository()) {
        self.locationRepository = locationRepository
    }

    func save(location: Location) {
        locationRepository.save(location: location)
    }
}
