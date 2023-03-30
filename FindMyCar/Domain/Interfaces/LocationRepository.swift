//
//  LocationRepository.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/29.
//

import Foundation

protocol LocationRepository {

    func fetchLocation(completion: @escaping (Result<Location?, Error>) -> Void)
    func save(location: Location)
}
