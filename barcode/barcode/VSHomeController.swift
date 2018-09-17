//
//  VSHomeController.swift
//  Scanner
//
//  Created by Scrupulous on 16/9/18.
//  Copyright © 2018 Md. Mamun-Ur-Rashid. All rights reserved.
//

import UIKit

class VSHomeController: UIViewController {
    
    @IBOutlet weak var scanner : VSScanner!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scanner.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scanner.viewDidAppear()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.scanner.viewWillDisappear()
    }

    // MARK:- Memory management

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension VSHomeController : VSScannerDelegate {
    
    func didScan(readableObject information: String?) {

        let barcode = VSBarcode.init(withName: information, withDate: Date())
        
        VSDatabaseManager.shared.addBarcode(withBarcode: barcode) { (barcode) in
           
            DispatchQueue.main.async {
                
                let controller = VSResultController.initWithStoryboard(withInformation: barcode?.name)
                self.present(controller, animated: true) {
                    self.scanner.startScanProcess()
                }
                
            }
 
        }
        
    }

}

