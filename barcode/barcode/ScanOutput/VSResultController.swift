//
//  VSResultController.swift
//  Scanner
//
//  Created by Scrupulous on 16/9/18.
//  Copyright © 2018 Md. Mamun-Ur-Rashid. All rights reserved.
//

import UIKit

class VSResultController: UIViewController {

    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var resultView:UITableView!
    
    var items : NSMutableArray = []
    var readableInformation : String?
    
    class func initWithStoryboard(withInformation information: String?) -> VSResultController {
        
        let storyboard  = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "VSResultController") as! VSResultController
        controller.readableInformation = information
        return controller ;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeTableview()
        self.lblResult.text = self.readableInformation;
        
        VSDatabaseManager.shared.getBarcodeList { (barcodes) in
            if barcodes.count > 0 {
                DispatchQueue.main.async {
                    self.items.addObjects(from: barcodes.reversed())
                    self.resultView.reloadData()
                }
            }
        }
        
    }
    
    func initializeTableview() {

        self.resultView.register(UINib(nibName: "VSHistoryCell", bundle:nil), forCellReuseIdentifier: "VSHistoryCell");
        self.resultView.separatorStyle = .none
        self.resultView.estimatedRowHeight = 44
        self.resultView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func tryAgainAction(sender: UIButton) {
        self.dismiss(animated: true, completion: .none)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension VSResultController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VSHistoryCell", for: indexPath) as! VSHistoryCell
        let selectedBarcode  = self.items[indexPath.row];
        cell.setInformationOnView(withItem: selectedBarcode as! VSBarcode)
        return cell
        
    }
    
}

extension VSResultController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableViewAutomaticDimension
        
    }
  
}

