//
//  TaskDetailsViewController.swift
//  TableView-CoreData-Practice6
//
//  Created by Tatsuya Moriguchi on 4/12/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData


class TaskDetailsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var toDoText: UITextField!
    @IBOutlet weak var isImpBool: UISwitch!
    @IBOutlet weak var isUrgBool: UISwitch!
    @IBOutlet weak var isDoneBool: UISwitch!
    @IBAction func backOnPressed(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    // Mark: -
    // To update a task content, declare a variable property,, task, of type 'Task?'
    var task: Task?
    
    // MARK: - Declare a Core Data property.
    var managedObjectContext: NSManagedObjectContext?
    
    
    
    @IBAction func saveOnPressed(_ sender: Any) {

        //guard let managedObjectContext = managedObjectContext else { return }
        // If the task property has a value, don't instantiate a new Task instance.
        // Instead, update it with the values of the text field and text view To update a task content.
        
        /*
        if task == nil {
            // Create Task
            let newTask = Task(context: managedObjectContext)
            // Configure Task
            //newTask.createdAt = Date().timeIntervalSince1970
            
            // Set Quote
            task = newTask
        }
 */
        //if toDoText.text == "" {
        if (toDoText.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            
            inputAlert()
        } else if let task = task {
            // Configure Quote
            task.toDo = toDoText.text
            task.isImportant = isImpBool.isOn
            task.isUrgent = isUrgBool.isOn
            task.isDone = isDoneBool.isOn

            // Go back to ViewController
            performSegueToReturnBack()

        } else { print("Hmm?? something wrong with @IBAction func saveOnPressed.")}
    }

    func inputAlert() {
        let alert = UIAlertController(title: "Alert!", message: "Please Type a To-Do.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    
    
    // To hold a value from previous view controller
    var detailToDo: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To update a quote content, Poputae the text field and text view
        // if the quote property has a value.
        if let task = task {
            toDoText.text = task.toDo
            isImpBool.isOn = (task.isImportant)
            isUrgBool.isOn = (task.isUrgent)
            isDoneBool.isOn = (task.isDone)
        }
        // To dimiss a keyboard when touching else or pressing a return key
        toDoText.delegate = self

    }
    
    // To dimiss a keyboard when touching else.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // To dimiss a keyboard when pressing a return key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        toDoText.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        toDoText.resignFirstResponder()
        return
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
            print("no navigation controller?")
        }
    }
}
