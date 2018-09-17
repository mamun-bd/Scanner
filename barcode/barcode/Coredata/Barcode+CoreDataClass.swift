//
//  Barcode+CoreDataClass.swift
//  Scanner
//
//  Created by Scrupulous on 16/9/18.
//  Copyright © 2018 Md. Mamun-Ur-Rashid. All rights reserved.
//

import Foundation
import CoreData

@objc(Barcode)
public class Barcode: NSManagedObject {

    func toBarcode() -> VSBarcode
    {
        return VSBarcode.init(withName: readableString, withDate: time! as Date)
    }
    
}
