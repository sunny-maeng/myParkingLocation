//
//  Location.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/22.
//

import Foundation

struct Location {

    let locationType: LocationType
    let latitude: Double?
    let longitude: Double?
    let locationImage: Data?

    init(latitude: Double, longitude: Double) {
        self.locationType = .coordinate
        self.latitude = latitude
        self.longitude = longitude
        self.locationImage = nil
    }

    init?(locationType: LocationType, locationImage: Data) {
        guard locationType != .coordinate else { return nil }
        self.locationType = locationType
        self.latitude = nil
        self.longitude = nil
        self.locationImage = locationImage
    }
}
