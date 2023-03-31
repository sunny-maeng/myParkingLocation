//
//  DataMapping.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/29.
//

import Foundation
import CoreData

struct DataMapping {

    func coreDataLocationEntityToDomain(from coreDataEntity: ParkingLocation) -> Location? {
        switch coreDataEntity.locationType {
        case 0:
            return Location(latitude: coreDataEntity.latitude, longitude: coreDataEntity.longitude)
        default:
           guard let locationType = LocationType.init(rawValue: Int(coreDataEntity.locationType)),
                 let imageData = coreDataEntity.imageData,
                 let location = Location(locationType: locationType, locationImage: imageData) else {
               return nil
           }
               return location
        }
    }

    func domainToCoreDataLocationEntity(from domain: Location,
                                        coreStorageContext: NSManagedObjectContext) -> ParkingLocation {
        let parkingLocationEntity = ParkingLocation(context: coreStorageContext)

        let locationTypeValue = Int64(domain.locationType.rawValue)
        parkingLocationEntity.locationType = locationTypeValue

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
