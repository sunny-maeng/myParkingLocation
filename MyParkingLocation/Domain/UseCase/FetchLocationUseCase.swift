//
//  Usecases.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/29.
//

import Foundation

protocol FetchLocationUseCase {

    func fetchLocation(completion: @escaping (Result<Location?, Error>) -> Void)
}

final class DefaultFetchLocationUseCase: FetchLocationUseCase {

    private let locationRepository: LocationRepository

    init(locationRepository: LocationRepository = DefaultLocationRepository()) {
        self.locationRepository = locationRepository
    }

    func fetchLocation(completion: @escaping (Result<Location?, Error>) -> Void) {
        locationRepository.fetchLocation { result in
            completion(result)
        }
    }
}
