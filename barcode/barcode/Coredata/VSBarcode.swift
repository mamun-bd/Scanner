//
//  VSBarcode.swift
//  Scanner
//
//  Created by Scrupulous on 16/9/18.
//  Copyright © 2018 Md. Mamun-Ur-Rashid. All rights reserved.
//

import UIKit

class VSBarcode: NSObject {
    
    var name: String?
    var time: Date?
   
    convenience init(withName name:String?, withDate date:Date?) {
        self.init()
        self.name = name
        self.time = date
    }

}

