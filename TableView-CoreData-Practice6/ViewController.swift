//
//  ViewController.swift
//  TableView-CoreData-Practice6
//
//  Created by Tatsuya Moriguchi on 3/26/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {

/*
    var tasks: [(toDoInput:String, isImportantInput: Bool, isUrgentInput: Bool, isDoneInput: Bool)] = [
        ("Research on Alpha Romeo Giulia quallity.", false, false, false),
        ("Research on Alpha Romeo Giulia's cost.", false, false, false),
        ("Research Alpha Romeo Giulia's dealer's reputation.", false, false, false),
        ("Compare between cash vs. loan vs. lease for two years.", false, false, false),
        ("Research on Toyota Hilander's resale value.", false, false, false),
        ("Research on where to sell Hilander.", false, false, false),
        ]
*/

/*        var tasks: [String] = [
        "Research on Alpha Romeo Giulia quallity.",
        "Research on Alpha Romeo Giulia's cost.",
        "Research Alpha Romeo Giulia's dealer's reputation.",
        "Compare between cash vs. loan vs. lease for two years.",
        "Research on Toyota Hilander's resale value.",
        "Research on where to sell Hilander."
        ]
*/
    

    // Declare a variable to be used across this class as Core Data
    var tasks : [Task] = []
    
    // For Core Data, create a variable
    var managedObjectContext:NSManagedObjectContext!


    @IBOutlet weak var toDoInput: UITextField!
    @IBOutlet weak var isImportantInput: UISwitch!
    @IBOutlet weak var isUrgentInput: UISwitch!
    @IBOutlet weak var isDoneInput: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!

    
    @IBAction func edit(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
        switch tableView.isEditing {
        case true:
            editButton.title = "Done"
            saveButton.isEnabled = false
        case false:
            editButton.title = "Edit"
            saveButton.isEnabled = true

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // For Vore Data, initialize managedObjectContext
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Get the data from core data
        getData()
        
        // Reload the table view
        tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        
        // Show an alert if no toDoInput text.
        if toDoInput.text == "" {
          // Alert must be before referencing managedObjectContext to avoid empty data addition.
            inputAlert()
            
        } else {
            let taskItem = Task(context: managedObjectContext)
            
            taskItem.toDo = toDoInput.text
            taskItem.isImportant = isImportantInput.isOn
            taskItem.isUrgent = isUrgentInput.isOn
            taskItem.isDone = isDoneInput.isOn

            insertNewTask()
            
            // Reload the table view
            getData()
    
        }
        
        tableView.reloadData()

        // Set switches back to default, False, for new input
        isImportantInput.setOn(false, animated: true)
        isUrgentInput.setOn(false, animated: true)
        isDoneInput.setOn(false, animated: true)
        toDoInput.text = ""

        
    }
    
    func inputAlert() {
        let alert = UIAlertController(title: "Alert!", message: "Please Type a To-Do.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    func insertNewTask() {

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
/*        taskItem.append(toDoInput.text!)
        let indexPath = IndexPath(row: taskItem.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
*/
        view.endEditing(true)
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")

        let task = tasks[indexPath.row]
     
        
        if task.isDone {
            cell?.textLabel?.text = task.toDo!
            cell?.textLabel?.textColor = UIColor.lightGray
        
        }else{
        
            if task.isImportant && task.isUrgent {
                cell?.textLabel?.text = "⭐️\(task.toDo!)"
                cell?.textLabel?.textColor = UIColor.red

            }else if task.isImportant && !task.isUrgent {
                cell?.textLabel?.text = "⭐️\(task.toDo!)"
                
            }else if !task.isImportant && task.isUrgent {
                cell?.textLabel?.text = task.toDo!
                cell?.textLabel?.textColor = UIColor.red

            }else{
                cell?.textLabel?.text = task.toDo!
            
            }
        }
        return cell!
    
    }
    
    
    func getData() {
        // Fetch data from Core Data to viewWillappear
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            tasks = try context.fetch(Task.fetchRequest())
        }catch {
            print("FetchingFailed for adding")
        }
        
    }
    

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // Reload the data
            do {
                tasks = try context.fetch(Task.fetchRequest())
            } catch {
                print("Fetching Failed for delete")
            }
            
        
            
            /*
            // remove it from table view where you swipe.
            tasks.remove(at: indexPath.row)
            // Update the table view
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.endUpdates()
             */
        
        }
        tableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        

        
        let task = tasks[sourceIndexPath.row]
        
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)


        /*
         
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
         (UIApplication.shared.delegate as! AppDelegate).saveContext()
         
         
        // Reload the data
        do {
            tasks = try context.fetch(Task.fetchRequest())
        } catch {
            print("Fetching Failed for delete")
        }
        
        tableView.reloadData()
*/
    
    }
    
    // Allows reordering of cells
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {



        
        return true
    }
}

