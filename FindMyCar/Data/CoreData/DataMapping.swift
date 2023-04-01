//
//  DataMapping.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/29.
//

import Foundation
import CoreData

struct DataMapping {

    func coreDataLocationEntityToDomain(from entity: ParkingLocation) -> Location? {
        switch entity.locationType {
        case 0:
            return Location(latitude: entity.latitude, longitude: entity.longitude, locationImage: entity.imageData)
        default:
           guard let locationType = LocationType.init(rawValue: Int(entity.locationType)),
                 let imageData = entity.imageData,
                 let location = Location(locationType: locationType, locationImage: imageData) else {
               return nil
           }
               return location
        }
    }

    func domainToCoreDataLocationEntity(from domain: Location,
                                        coreStorageContext: NSManagedObjectContext) -> ParkingLocation {
        let entity = ParkingLocation(context: coreStorageContext)

        let locationTypeValue = Int64(domain.locationType.rawValue)
        entity.locationType = locationTypeValue

        if let imageData = domain.locationImage {
            entity.imageData = imageData
        }

        if let latitude = domain.latitude,
           let longitude = domain.longitude {
            entity.latitude = latitude
            entity.longitude = longitude
        }

        return entity
    }
}
