//
//  TableViewCell.swift
//  MyCoreDataDemo
//
//  Created by Suraj Prasad on 14/03/19.
//  Copyright © 2019 Suraj Prasad. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var childrenDetail: UILabel!
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
