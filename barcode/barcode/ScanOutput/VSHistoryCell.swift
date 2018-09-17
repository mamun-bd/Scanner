//
//  VSHistoryCell.swift
//  Scanner
//
//  Created by Scrupulous on 16/9/18.
//  Copyright © 2018 Md. Mamun-Ur-Rashid. All rights reserved.
//

import UIKit

class VSHistoryCell: UITableViewCell {
    
    @IBOutlet weak var lblInformation: UILabel!
    @IBOutlet weak var lblTime:UILabel!

    var barcode : VSBarcode?
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setInformationOnView(withItem item:VSBarcode){
        self.barcode = item;
        self.lblInformation.text = item.name;
        self.lblTime.text = item.time?.description
    }
    
}
