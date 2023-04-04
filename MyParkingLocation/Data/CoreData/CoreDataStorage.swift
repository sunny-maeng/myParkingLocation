//
//  CoreDataStorage.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/29.
//

import Foundation
import CoreData

final class CoreDataStorage {

    static let shared: CoreDataStorage = CoreDataStorage()

    private init() {}

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.parkingLocationContainer)
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    var context: NSManagedObjectContext { return persistentContainer.viewContext }
}

extension CoreDataStorage {

    private enum Constant {
        static let parkingLocationContainer = "ParkingLocation"
    }
}
