//
//  VSScannerDelegate.swift
//  Scanner
//
//  Created by Scrupulous on 16/9/18.
//  Copyright © 2018 Md. Mamun-Ur-Rashid. All rights reserved.
//


import UIKit

protocol VSScannerDelegate : NSObjectProtocol {

    func didScan(readableObject information: String?)
  
}

