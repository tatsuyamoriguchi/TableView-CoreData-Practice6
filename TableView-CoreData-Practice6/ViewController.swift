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

        var tasks: [String] = [
        "Research on Alpha Romeo Giulia quallity.",
        "Research on Alpha Romeo Giulia's cost.",
        "Research Alpha Romeo Giulia's dealer's reputation.",
        "Compare between cash vs. loan vs. lease for two years.",
        "Research on Toyota Hilander's resale value.",
        "Research on where to sell Hilander."
        ]


    @IBOutlet weak var toDoInput: UITextField!
    @IBOutlet weak var isImportantInput: UISwitch!
    @IBOutlet weak var isUrgentInput: UISwitch!
    @IBOutlet weak var isDoneInput: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toDoText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        insertNewTask()
        
    }

    func insertNewTask() {
        tasks.append(toDoInput.text!)
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        toDoInput.text = ""
        view.endEditing(true)
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")

        cell?.textLabel?.text = task
        
        return cell!
    
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove it from table view where you swipe.
            tasks.remove(at: indexPath.row)
            // Update the table view
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        //tasks.insert(task, at: to.row)
        tasks.insert(task, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

