//
//  DataMapping.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/29.
//

import Foundation
import CoreData

struct DataMapping {

    func coreDataLocationEntityToDomain(from coreDataEntity: ParkingLocation) -> Location {
        return .init(latitude: coreDataEntity.latitude,
                     longitude: coreDataEntity.longitude,
                     locationImage: coreDataEntity.imageData)
    }

    func domainToCoreDataLocationEntity(from domain: Location,
                                        coreStorageContext: NSManagedObjectContext) -> ParkingLocation {
        let parkingLocationEntity = ParkingLocation(context: coreStorageContext)

        if let latitude = domain.latitude,
            let longitude = domain.longitude {
            parkingLocationEntity.latitude = latitude
            parkingLocationEntity.longitude = longitude
        } else if let imageData = domain.locationImage {
            parkingLocationEntity.imageData = imageData
        }

        return parkingLocationEntity
    }
}
