//
//  DefaultLocationRepository.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/29.
//

import Foundation

final class DefaultLocationRepository {

    private let locationStorage: LocationStorage

    init(locationStorage: LocationStorage = CoreDataLocationStorage()) {
        self.locationStorage = locationStorage
    }
}

extension DefaultLocationRepository: LocationRepository {

    func fetchLocation(completion: @escaping (Result<Location?, Error>) -> Void) {
        locationStorage.fetchLocation { result in
            completion(result)
        }
    }

    func save(location: Location) {
        locationStorage.save(location)
    }

    func deleteLocation() {
        locationStorage.deleteLocation()
    }
}
