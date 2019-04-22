//
//  ViewController.swift
//  MyCoreDataDemo
//
//  Created by Suraj Prasad on 14/03/19.
//  Copyright © 2019 Suraj Prasad. All rights reserved.
//  /Users/surajprasad/Library/Developer/CoreSimulator/Devices/9483753E-1359-4777-8302-0391EDDFD8CC/data/Containers/Data/Application/737EE600-1F69-4FAB-B0A5-29B8761F96FE/Documents

import UIKit
import CoreData
class ViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var enterMob: UITextField!
    @IBOutlet weak var enterDOB: UITextField!
    
    @IBOutlet weak var NoOfChildren: UILabel!
    @IBOutlet weak var child1Name: UITextField!
    
    @IBOutlet weak var child1DOB: UITextField!
    @IBOutlet weak var child2Name: UITextField!
    @IBOutlet weak var child2DOB: UITextField!
    @IBOutlet weak var child3Name: UITextField!
    @IBOutlet weak var child3DOB: UITextField!
    @IBOutlet weak var child1View: UIView!
    @IBOutlet weak var child2View: UIView!
    @IBOutlet weak var child3View: UIView!
    @IBOutlet var addChildren: UIView!
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataBase()
    }
    override func viewWillAppear(_ animated: Bool) {
        NoOfChildren.text = "0"
        child1View.isUserInteractionEnabled = false
        child1View.alpha = 0
        child2View.isUserInteractionEnabled = false
        child2View.alpha = 0
        child3View.isUserInteractionEnabled = false
        child3View.alpha = 0
    }
    //MARK:- Helper Methods
    //function that fetch data
    func fetchDataBase(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            //employee data
            let frequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Employee")
            do {
                let employeeResult = try context.fetch(frequest)
                guard let tabbar = tabBarController as? TabController else { return }
                tabbar.mobileArray = []
                tabbar.nameArray = []
                tabbar.dobArray = []
                for obj in employeeResult {
                    if let obj = obj as? Employee {
                        tabbar.nameArray.append(obj.name!)
                        tabbar.mobileArray.append(obj.mobile)
                        tabbar.dobArray.append(obj.dob!)
                    }
                }
                print(tabbar.nameArray)
                
            }catch {
                print("Not able to fetch")
            }
            saveChanges()
        }
    }
    // function that Saves any changes in the context
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
    // function to set default value of labels
    func defaultValues() {
        enterName.text = ""
        enterDOB.text = ""
        enterMob.text = ""
        child1Name.text = ""
        child2Name.text = ""
        child3Name.text = ""
        child1DOB.text = ""
        child2DOB.text = ""
        child3DOB.text = ""
        NoOfChildren.text = "0"
    }
    //MARK:- IBActions
    @IBAction func addChildrenBtn(_ sender: UIStepper) {
        NoOfChildren.text = Int(sender.value).description
        if NoOfChildren.text == "0" {
            child1View.isUserInteractionEnabled = false
            child1View.alpha = 0
            child2View.isUserInteractionEnabled = false
            child2View.alpha = 0
            child3View.isUserInteractionEnabled = false
            child3View.alpha = 0
        }else if NoOfChildren.text == "1" {
            child1View.isUserInteractionEnabled = true
            child1View.alpha = 1
            child2View.isUserInteractionEnabled = false
            child2View.alpha = 0
            child3View.isUserInteractionEnabled = false
            child3View.alpha = 0
        }
        else if NoOfChildren.text == "2" {
            child1View.isUserInteractionEnabled = true
            child1View.alpha = 1
            child2View.isUserInteractionEnabled = true
            child2View.alpha = 1
            child3View.isUserInteractionEnabled = false
            child3View.alpha = 0
        } else {
            child1View.isUserInteractionEnabled = true
            child1View.alpha = 1
            child2View.isUserInteractionEnabled = true
            child2View.alpha = 1
            child3View.isUserInteractionEnabled = true
            child3View.alpha = 1
        }
    }
    //for saving data in DB
    @IBAction func tapSave(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let tabbar = tabBarController as? TabController else{return}
        tabbar.totalChildOfEachEmployee.append(Int(NoOfChildren.text!)!)
        
        // mobile and DOB validate then work
        if enterMob.text!.isValidContact == true && dateFormatter.date(from: enterDOB.text!) !=  nil && enterName.text != ""{
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext
                // User
                let employeeEntity = NSEntityDescription.entity(forEntityName: "Employee", in: context)
                let employee = NSManagedObject(entity: employeeEntity!, insertInto: context)
                let childrenEntity = NSEntityDescription.entity(forEntityName: "Children", in: context)
                
                let child1 = NSManagedObject(entity: childrenEntity!, insertInto: context)
                let child2 = NSManagedObject(entity: childrenEntity!, insertInto: context)
                let child3 = NSManagedObject(entity: childrenEntity!, insertInto: context)
                
                employee.setValue(enterName.text, forKeyPath: "name")
                let toIntegerMobile = Int64(enterMob.text ?? " ")
                employee.setValue(toIntegerMobile, forKeyPath: "mobile")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.date(from: enterDOB.text!)
                employee.setValue(date, forKeyPath: "dob")
                //children
                let employees = employee.mutableSetValue(forKey: "children")
                if NoOfChildren.text! == "1" && child1Name.text != "" && dateFormatter.date(from: child1DOB.text!) != nil {
                    child1.setValue(child1Name.text, forKeyPath: "name")
                    child1.setValue(dateFormatter.date(from: child1DOB.text!), forKeyPath: "dob")
                    child1.setValue(employee, forKey: "employee")
                    employees.add(child1)
                    
                }else if NoOfChildren.text!=="2" && child1Name.text != "" && dateFormatter.date(from: child1DOB.text!) != nil && child2Name.text != "" && dateFormatter.date(from: child2DOB.text!) != nil{
                    child1.setValue(child1Name.text, forKeyPath: "name")
                    child1.setValue(dateFormatter.date(from: child1DOB.text!), forKeyPath: "dob")
                    child1.setValue(employee, forKey: "employee")
                    employees.add(child1)
                    child2.setValue(child2Name.text, forKeyPath: "name")
                    child2.setValue(dateFormatter.date(from: child2DOB.text!), forKeyPath: "dob")
                    child2.setValue(employee, forKey: "employee")
                    employees.add(child2)
                    
                }else if NoOfChildren.text! == "3" && child1Name.text != "" && dateFormatter.date(from: child1DOB.text!) != nil && child2Name.text != "" && dateFormatter.date(from: child2DOB.text!) != nil && child3Name.text != "" && dateFormatter.date(from: child3DOB.text!) != nil{
                    child1.setValue(child1Name.text, forKeyPath: "name")
                    child1.setValue(dateFormatter.date(from: child1DOB.text!), forKeyPath: "dob")
                    child1.setValue(employee, forKey: "employee")
                    employees.add(child1)
                    child2.setValue(child2Name.text, forKeyPath: "name")
                    child2.setValue(dateFormatter.date(from: child2DOB.text!), forKeyPath: "dob")
                    child2.setValue(employee, forKey: "employee")
                    employees.add(child2)
                    child3.setValue(child3Name.text, forKeyPath: "name")
                    child3.setValue(dateFormatter.date(from: child3DOB.text!), forKeyPath: "dob")
                    child3.setValue(employee, forKey: "employee")
                    employees.add(child3)
               
                } else {
                    let alert = UIAlertController(title: "Warning", message:"Children data not properly filed.No children data will be displayed on profile." , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                saveChanges()
            }
            fetchDataBase()
            defaultValues()
            print("Data saved successfully")
        }
        else {
            if enterName.text == "" {
                let alert = UIAlertController(title: "Name Field Empty", message:"" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            if enterMob.text!.isValidContact == false {
                let alert = UIAlertController(title: "Wrong Mobile Number Format", message: "Must start from 6-9 and total 10 digits", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            if dateFormatter.date(from: enterDOB.text!) ==  nil{
                let alert = UIAlertController(title: "Wrong D.O.B Format", message:"use dd/MM/YYYY format" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
//MARK:- Extension for phone Validation
// Used for phone number Validation
extension String {
    var isValidContact: Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
}
