//
//  LocationCRUDStorage.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/29.
//

import Foundation
import CoreData

protocol LocationStorage {

    func save(_ location: Location)
    func fetchLocation(completion: @escaping(Result<Location?, Error>) -> Void)
    func deleteLocation()
}

final class CoreDataLocationStorage {

    private let coreDataStorage: CoreDataStorage
    private let dataMapping: DataMapping

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared,
         dataMapping: DataMapping = DataMapping()) {
        self.coreDataStorage = coreDataStorage
        self.dataMapping = dataMapping
    }
}

extension CoreDataLocationStorage: LocationStorage {
    func save(_ location: Location) {
        deleteLocation()
        _ = dataMapping.domainToCoreDataLocationEntity(from: location, coreStorageContext: coreDataStorage.context)

        do {
            try coreDataStorage.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchLocation(completion: @escaping(Result<Location?, Error>) -> Void) {
        let request = ParkingLocation.fetchRequest()

        do {
            let fetchedData = try coreDataStorage.context.fetch(request)

            if let parkingLocation = fetchedData.first {
                let location = dataMapping.coreDataLocationEntityToDomain(from: parkingLocation)
                completion(.success(location))
            } else {
                completion(.success(nil))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func deleteLocation() {
        let request: NSFetchRequest<ParkingLocation> = NSFetchRequest(entityName: Constant.parkingLocationContainer)

        do {
            let locations = try coreDataStorage.context.fetch(request)
            locations.forEach { coreDataStorage.context.delete($0) }
            try coreDataStorage.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension CoreDataLocationStorage {

    private enum Constant {
        static let parkingLocationContainer = "ParkingLocation"
    }
}
