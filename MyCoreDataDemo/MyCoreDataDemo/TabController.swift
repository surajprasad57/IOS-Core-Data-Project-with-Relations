//
//  TabController.swift
//  MyCoreDataDemo
//
//  Created by Suraj Prasad on 15/03/19.
//  Copyright © 2019 Suraj Prasad. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    //MARK:- userDefined Variables
    var nameArray = [String]()
    var mobileArray = [Int64]()
    var dobArray = [Date]()
    var totalChildOfEachEmployee = [Int]()
    var rowNo = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
