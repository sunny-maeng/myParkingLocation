//
//  Location.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/22.
//

import Foundation

struct Location {

    let latitude: Double?
    let longitude: Double?
    let locationImage: Data?

    init(latitude: Double? = nil, longitude: Double? = nil, locationImage: Data? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationImage = locationImage
    }
}
