//
//  VSDatabaseManager.swift
//  Scanner
//
//  Created by Scrupulous on 16/9/18.
//  Copyright © 2018 Md. Mamun-Ur-Rashid. All rights reserved.
//

import UIKit
import CoreData

class VSDatabaseManager {

    static let shared = VSDatabaseManager()
   
    var sourcePath:URL? {
        
        guard let sourceURL = Bundle.main.url(forResource: "barcode", withExtension: "momd") else { print("Error loading model from bundle")
              return .none

        }
        return sourceURL
    }
    
    var destPath:String? {
        
        guard sourcePath != .none else { return .none }
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return (directory as NSString).appendingPathComponent("barcode.sqlite")
    
    }

    private lazy var mainManagedObjectContext: NSManagedObjectContext = {

        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        return moc
        
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = mainManagedObjectContext
        return moc
        
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: sourcePath!) else {
            fatalError("Error initializing mom from: \(sourcePath!)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        return psc
        
    }()
    
  
    private init() {
        
        let destination = destPath ?? ""
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: URL.init(fileURLWithPath: destination), options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }

        mainManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    deinit
    {
        do {
            try self.mainManagedObjectContext.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
  
    func addBarcode(withBarcode information: VSBarcode, completionHandler: @escaping (VSBarcode?) -> Void)
    {

        privateManagedObjectContext.perform {
            do {
                let managedUser = NSEntityDescription.insertNewObject(forEntityName: "Barcode", into: self.privateManagedObjectContext) as! Barcode
                managedUser.readableString = information.name
                managedUser.time = information.time! as NSDate
                try self.privateManagedObjectContext.save()
                try self.mainManagedObjectContext.save()
                completionHandler(information)
            } catch {
                completionHandler(nil)
            }
        }
    }

    func getBarcodeList(completionHandler: @escaping ([VSBarcode]) -> Void)
    {

        privateManagedObjectContext.perform {
            do {
                let fetchRequest : NSFetchRequest<Barcode> = Barcode.fetchRequest()
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                let barcodes = results.map { $0.toBarcode() }
                completionHandler(barcodes)
            } catch {
                completionHandler([])
            }
        }

    }

}
