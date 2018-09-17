//
//  Barcode+CoreDataProperties.swift
//  Scanner
//
//  Created by Scrupulous on 16/9/18.
//  Copyright © 2018 Md. Mamun-Ur-Rashid. All rights reserved.
//

import Foundation
import CoreData


extension Barcode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Barcode> {
        return NSFetchRequest<Barcode>(entityName: "Barcode")
    }

    @NSManaged public var readableString: String?
    @NSManaged public var time: NSDate?

}
