//
//  displayTableVC.swift
//  MyCoreDataDemo
//
//  Created by Suraj Prasad on 14/03/19.
//  Copyright © 2019 Suraj Prasad. All rights reserved.
//
import UIKit
import CoreData
class displayTableVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK:- UserDefined variables
    var rowNo:Int = 0
    var defaultDate:Date? = nil
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        print("view will appear table view")
    }
    //MARK:- Helper Methods
    //for fetching data from DB
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
    //Methods used for editing mode
    func openEditMode() {
        performSegue(withIdentifier: "UpdateVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UpdateVC {
            guard let tabbar = tabBarController as? TabController else {return}
            vc.getName = tabbar.nameArray[rowNo]
            vc.getMobile = String(tabbar.mobileArray[rowNo])
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            vc.getDOB = formatter.string(from: tabbar.dobArray[rowNo])
            vc.selectedRow = self.rowNo
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext
                let frequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Employee")
                var childrenNameArray = [String]()
                var childrenDobArray = [Date]()
                var index:Int = 0
                do {
                    let arrayOfEmployee = try context.fetch(frequest)
                    for obj in arrayOfEmployee {
                        if index == rowNo {
                            if let obj = obj as? Employee {
                                
                                for child in obj.children! {
                                    if let childObj = child as? Children {
                                        childrenNameArray.append(childObj.name ?? "N/A")
                                        childrenDobArray.append(childObj.dob ?? defaultDate!)
                                    }
                                }
                            }
                            if childrenNameArray.count == 1 {
                                vc.getChild1Name =  childrenNameArray.first!
                                vc.getChild1Dob = formatter.string(from: childrenDobArray.first!)
                                vc.childNo = 1
                            }
                            else if childrenNameArray.count == 2 {
                                vc.getChild1Name =  childrenNameArray.first!
                                vc.getChild1Dob = formatter.string(from: childrenDobArray.first!)
                                vc.getChild2Name =  childrenNameArray.last!
                                vc.getChild2Dob = formatter.string(from: childrenDobArray.last!)
                                vc.childNo = 2
                            }
                            else if childrenNameArray.count == 3 {
                                vc.getChild1Name =  childrenNameArray.first!
                                vc.getChild1Dob = formatter.string(from: childrenDobArray.first!)
                                vc.getChild2Name =  childrenNameArray[1]
                                vc.getChild2Dob = formatter.string(from: childrenDobArray[1])
                                vc.getChild3Name =  childrenNameArray.last!
                                vc.getChild3Dob = formatter.string(from: childrenDobArray.last!)
                                vc.childNo = 3
                            }else {
                                print("no child data found")
                            }
                        }
                        index = index + 1
                    }
                } catch {
                    print("Not able to fetch")
                }
                saveChanges()
            }
        }
    }
}
//MARK: Extension for tableView
extension displayTableVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let tabbar = tabBarController as? TabController else {return -1}
        return tabbar.nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
                //converting date to string
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    let context = appDelegate.persistentContainer.viewContext
                    
                    let frequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Employee")
                    var childrenNameArray = [String]()
                    var childrenDobArray = [Date]()
                    var indexChild = 0
                    var indexEmployee = 0
                    do {
                        let arrayOfEmployee = try context.fetch(frequest)
                        for obj in arrayOfEmployee {
                            
                            if let obj = obj as? Employee {
                                if indexEmployee == indexPath.row {
                                cell.lblName.text = obj.name
                                cell.lblMobile.text = String(obj.mobile)
                                cell.lblDOB.text = formatter.string(from: obj.dob!)
                                }
                                indexEmployee = indexEmployee + 1
                                for child in obj.children! {
                                    if let childObj = child as? Children {
                                        childrenNameArray.append(childObj.name ?? "N/A")
                                        childrenDobArray.append(childObj.dob!)
                                    }
                                }
                                print("this is children array ---- \(childrenNameArray) for emp \(obj.name!)")
                                if indexChild == indexPath.row {
                                    if childrenNameArray.count == 1 {
                                        cell.childrenDetail.text = " Child1 -> Name: \(childrenNameArray.first!) & DOB: \(formatter.string(from: childrenDobArray.first!))"
                                    }
                                    else if childrenNameArray.count == 2 {
                                        cell.childrenDetail.text = " Child1 -> Name: \(childrenNameArray.first!) & DOB: \(formatter.string(from: childrenDobArray.first!)) \n Child2 -> Name: \(childrenNameArray.last!) & DOB: \(formatter.string(from: childrenDobArray.last!))"
                                    }
                                    else if childrenNameArray.count == 3 {
                                        cell.childrenDetail.text = " Child1 -> Name: \(childrenNameArray.first!) & DOB: \(formatter.string(from: childrenDobArray.first!)) \n Child2 -> Name: \(childrenNameArray[1]) & DOB: \(formatter.string(from: childrenDobArray[1]))\n Child3 -> Name: \(childrenNameArray.last!) & DOB: \(formatter.string(from: childrenDobArray.last!))"
                                    }else {
                                        cell.childrenDetail.text = "No Child Available"
                                    }
                                }
                                indexChild = indexChild+1
                            }
                            childrenNameArray = []
                            childrenDobArray = []
                        }
                    } catch {
                        print("Not able to fetch")
                    }
                    saveChanges()
            }
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.yellow
            } else {
                cell.backgroundColor = UIColor.green
            }
            return cell
        }
        
        return TableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // ActionSheet for edit and delete rows of table
        let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let editButton = UIAlertAction(title: "Edit Row", style: .default, handler: { (action) -> Void in
            print("Edit button tapped")
            self.rowNo = indexPath.row
            // tabbar.updateData(rowNo: indexPath.row)
            self.openEditMode()
        })
        let  deleteButton = UIAlertAction(title: "Delete Row", style: .destructive, handler: { (action) -> Void in
            print("Delete button tapped")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let frequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Employee")
            do {
                let arrayOfEmployee = try context.fetch(frequest)
               
                print("deleted employee --> \(arrayOfEmployee[indexPath.row])")
               
                context.delete((arrayOfEmployee[indexPath.row] as? NSManagedObject)!)
                self.saveChanges()
            }
            catch {
                print("Not able to fetch")
            }
           
            self.fetchDataBase()
            tableView.reloadData()
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        alertController.addAction(editButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
