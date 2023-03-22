//
//  location.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/22.
//

import Foundation
import CoreLocation

protocol LocationProvider {

    func fetchLocation() -> Location
}
