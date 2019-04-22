//
//  UpdateVC.swift
//  MyCoreDataDemo
//
//  Created by Suraj Prasad on 27/03/19.
//  Copyright © 2019 Suraj Prasad. All rights reserved.
//

import UIKit
import CoreData
class UpdateVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var updateName: UITextField!
    @IBOutlet weak var updateMobile: UITextField!
    @IBOutlet weak var updateDOB: UITextField!
    @IBOutlet weak var updateChild1Name: UITextField!
    @IBOutlet weak var updateChild2Name: UITextField!
    @IBOutlet weak var updateChild3Name: UITextField!
    @IBOutlet weak var updateChild1Dob: UITextField!
    @IBOutlet weak var updateChild2Dob: UITextField!
    @IBOutlet weak var updateChild3Dob: UITextField!
    @IBOutlet weak var updateChild1View: UIView!
    @IBOutlet weak var updateChild2View: UIView!
    @IBOutlet weak var updateChild3View: UIView!
    @IBOutlet weak var numOfChildren: UILabel!
    
    //MARK:- Global Variables
    var getName:String = ""
    var getMobile:String = ""
    var getDOB:String = ""
    var getChild1Name:String = ""
    var getChild2Name:String = ""
    var getChild3Name:String = ""
    var getChild1Dob:String = ""
    var getChild2Dob:String = ""
    var getChild3Dob:String = ""
    var childNo:Int = 0
    var selectedRow:Int = 0
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHandler(childNum: childNo)
        updateName.text = getName
        updateMobile.text = getMobile
        updateDOB.text = getDOB
        numOfChildren.text = String(childNo)
        if childNo == 1 {
            updateChild1Name.text = getChild1Name
            updateChild1Dob.text = getChild1Dob
        }else if childNo == 2 {
            updateChild1Name.text = getChild1Name
            updateChild1Dob.text = getChild1Dob
            updateChild2Name.text = getChild2Name
            updateChild2Dob.text = getChild2Dob
        } else if childNo == 3 {
            updateChild1Name.text = getChild1Name
            updateChild1Dob.text = getChild1Dob
            updateChild2Name.text = getChild2Name
            updateChild2Dob.text = getChild2Dob
            updateChild3Name.text = getChild3Name
            updateChild3Dob.text = getChild3Dob
        } else {
            print("no child data to update")
        }
        // Do any additional setup after loading the view.
    }
    //MARK:- Helper Methods
    func viewHandler(childNum: Int){
        if childNum == 0 {
            updateChild1View.alpha = 0
            updateChild1View.isUserInteractionEnabled = false
            updateChild2View.alpha = 0
            updateChild2View.isUserInteractionEnabled = false
            updateChild3View.alpha = 0
            updateChild3View.isUserInteractionEnabled = false
        }else if childNum == 1 {
            updateChild2View.alpha = 0
            updateChild2View.isUserInteractionEnabled = false
            updateChild3View.alpha = 0
            updateChild3View.isUserInteractionEnabled = false
        }else if childNum == 2 {
            updateChild3View.alpha = 0
            updateChild3View.isUserInteractionEnabled = false
        } else{
            print("3 child available..Showing all views")
        }
    }
    func saveChanges() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError {
            print("Error \(error.description)")
        }
    }
    //MARK:- IBActions
    @IBAction func tapUpdate(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        // mobile and DOB validate then work
        if updateMobile.text!.isValidContact == true && dateFormatter.date(from: updateDOB.text!) !=  nil && updateName.text != ""  {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            let frequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Employee")
            // let frequest1 = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Children")
            let predicateEmployee = NSPredicate(format: "mobile = %@", getMobile)
            frequest.predicate = predicateEmployee
            do {
                let resultEmployee = try context.fetch(frequest)
                
                if resultEmployee.count > 0{
                    let manageEmployee = resultEmployee[0] as! NSManagedObject
                    
                    manageEmployee.setValue(updateName.text!, forKey: "name")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    manageEmployee.setValue(formatter.date(from:updateDOB.text!), forKey: "dob")
                    manageEmployee.setValue(Int64(updateMobile.text!), forKey: "mobile")
                    print(updateName.text!)
                    saveChanges()
                    
                    var index = 1
                    for obj in resultEmployee {
                        
                        if let obj = obj as? Employee {
                            
                            for child in obj.children! {
                                if let childObj = child as? Children {
                                    
                                    if childNo == 1 {
                                        childObj.setValue(updateChild1Name.text, forKey: "name")
                                        childObj.setValue(formatter.date(from: updateChild1Dob.text!), forKey: "dob")
                                    }
                                    else if childNo == 2 {
                                        if index == 1{
                                            childObj.setValue(updateChild1Name.text, forKey: "name")
                                            childObj.setValue(formatter.date(from: updateChild1Dob.text!), forKey: "dob")
                                        }
                                        else{
                                            childObj.setValue(updateChild2Name.text, forKey: "name")
                                            childObj.setValue(formatter.date(from: updateChild2Dob.text!), forKey: "dob")
                                        }
                                    }
                                    else if childNo == 3 {
                                        if index == 1{
                                            childObj.setValue(updateChild1Name.text, forKey: "name")
                                            childObj.setValue(formatter.date(from: updateChild1Dob.text!), forKey: "dob")
                                        }
                                        else if index == 2{
                                            childObj.setValue(updateChild2Name.text, forKey: "name")
                                            childObj.setValue(formatter.date(from: updateChild2Dob.text!), forKey: "dob")
                                        } else {
                                            childObj.setValue(updateChild3Name.text, forKey: "name")
                                            childObj.setValue(formatter.date(from: updateChild3Dob.text!), forKey: "dob")
                                        }
                                    }
                                    index = index + 1
                                }
                            }
                        }
                    }
                    saveChanges()
                    print("update successful")
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    print("Record Not Found")
                }
            } catch  {
                print("Error Occured while updating")
            }
        }
        else {
            if updateName.text == "" {
                let alert = UIAlertController(title: "Name Field Empty", message:"" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            if updateMobile.text!.isValidContact == false {
                let alert = UIAlertController(title: "Wrong Mobile Number Format", message: "Must start from 6-9 and total 10 digits ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            if dateFormatter.date(from: updateDOB.text!) ==  nil{
                let alert = UIAlertController(title: "Wrong D.O.B Format", message:"use dd/MM/YYYY format" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    @IBAction func cancelUpdate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
