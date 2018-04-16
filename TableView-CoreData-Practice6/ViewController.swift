//
//  ViewController.swift
//  TableView-CoreData-Practice6
//
//  Created by Tatsuya Moriguchi on 3/26/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    private let Segue = "segue"
    
    private let persistentContainer = NSPersistentContainer(name: "Tasks")
    

    // Declare a variable to be used across this class as Core Data
    var tasks : [Task] = []
    
    // For Core Data, create a variable
    var managedObjectContext:NSManagedObjectContext!


    @IBOutlet weak var toDoInput: UITextField!
    @IBOutlet weak var isImportantInput: UISwitch!
    @IBOutlet weak var isUrgentInput: UISwitch!
    //@IBOutlet weak var isDoneInput: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var editButton: UIBarButtonItem!
   
    @IBOutlet weak var saveButton: UIButton!

    
    // Index Variable to pass data to TaskDetailControllerView, see prepareForSegue
    var taskIndex = 0
    
    
/*    @IBAction func edit(_ sender: Any) {
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
*/
    
    // The fetched results controller instance variable with the pretended entity
    // we want to fetch from the Core Data
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    // The proxy variable to serve as a lazy getter to our getched results controller
    var fetchedResultsController: NSFetchedResultsController<Task> {
        // If the varibale is alreay initialized, return that instance.
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        
        
        // If not, build the required elements for the fetched results controller
        
        // First need to create a fetch request with the pretended type.
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the batch size to a suitable number (optional)
        fetchRequest.fetchBatchSize = 20
        
        // Create at least one sort order attribute and type (ascending/descending)
        let sortDescriptor = NSSortDescriptor(key: "toDo", ascending: false)
        
        // Set the sort objects to the fetch request.
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Optionally, create a filter/predicate.
        // The goal of this predicate is to fetch Tasks that are not yet completed.
        let predicate = NSPredicate(format: "isDone == FALSE")
        
        // Set the created predicate to our fetch request.
        fetchRequest.predicate = predicate
        
        // Create the fetched results controller instance with the defined attributes.
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set the delegate of the fetched results controller to the view controller.
        // with this get notified whenever occurs changes on the data.
        aFetchedResultsController.delegate = self
        
        // Setting the created instance to the view controller instance.
        _fetchedResultsController = aFetchedResultsController
        
        do {
            // Perform the initial fetch to Core Data.
            // After this step, the fetched results controller will only retrive more records if neccesary.
            try _fetchedResultsController!.performFetch()
        }catch{
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // For Core Data, initialize managedObjectContext
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        

        // To dimiss a keyboard when touching else or pressing a return key
        toDoInput.delegate = self
    }
    
    // To dimiss a keyboard when touching else.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // To dimiss a keyboard when pressing a return key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        toDoInput.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        toDoInput.resignFirstResponder()
        return
        
    }
    
   override func viewWillAppear(_ animated: Bool) {
    
    getData()
    tableView.reloadData()
    
    }


    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        // Show an alert if no toDoInput text
        //if toDoInput.text == "" {
        if (toDoInput.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
        
          // Alert must be before referencing managedObjectContext to avoid empty data addition.
            inputAlert()
            
        } else {
            let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            //let task = Task(context: managedObjectContext)
            
            let taskItem = Task(context: managedObjectContext)
            
            
            taskItem.toDo = toDoInput.text
            taskItem.isImportant = isImportantInput.isOn
            taskItem.isUrgent = isUrgentInput.isOn
            //taskItem.isDone = isDoneInput.isOn
            taskItem.isDone = false


            insertNewTask()
            
            // Set switches back to default, False, for new input
            isImportantInput.setOn(false, animated: true)
            isUrgentInput.setOn(false, animated: true)
            //isDoneInput.setOn(false, animated: true)
            toDoInput.text = ""

            
            // Reload the table view
            getData()
            tableView.reloadData()
        
        }
        
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
        view.endEditing(true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationViewController = segue.destination as? TaskDetailsViewController else { return }
        // Configure View Controller
        destinationViewController.managedObjectContext = persistentContainer.viewContext
        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier ==  Segue{
            // Configure View Controller
            destinationViewController.task = fetchedResultsController.object(at: indexPath)
            
        }
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {

    // Whenver a change occurs, the fetched results controller will call the method controllerDidChangeContent from its delegate.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
    // Use the proxy variable to the fetched results controller ann from that, get the sections
        // from it. If not available, ignore and return none (0).
        return self.fetchedResultsController.sections?.count ?? 0
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return tasks.count
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")
        //let cell = UITableViewCell()
        // GEt a cell from the table view with the ID "TaskCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        //let task = tasks[indexPath.row]
        // Get the object at the current index from the fetched results controller
        let task = self.fetchedResultsController.object(at: indexPath)
        
        // Update the cell label with the task toDo
        //cell.textLabel!.text = task.toDo
            
        
        //Display font in red for Important task, and 🔥 for urgent ones.
         if task.isImportant == true && task.isUrgent == true {
        
            cell.textLabel?.text = "🔥\(task.toDo!)"
            cell.textLabel?.textColor = UIColor.red

        }else if task.isImportant == true && task.isUrgent == false {
        
         cell.textLabel?.text = task.toDo!
         cell.textLabel?.textColor = UIColor.red
         
        }else if task.isImportant == false && task.isUrgent == true {
        
            cell.textLabel?.text = "🔥\(task.toDo!)"
            cell.textLabel?.textColor = UIColor.black
            
        }else{
        
            cell.textLabel?.text = task.toDo
            cell.textLabel?.textColor = UIColor.black

        }
 
            
        return cell
    
    }
    
    
    func getData() {
        // Fetch data from Core Data to viewWillappear
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            tasks = try managedObjectContext.fetch(Task.fetchRequest())
        }catch {
            print("FetchingFailed for adding")
        }
        
    }
    

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
/*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            //context.delete(task)
            managedObjectContext.delete(task)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            

            getData()
            tableView.reloadData()
        
        }
    }
*/
 
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Show two options when a user swipes a cell.

        // A option to mark a task completed.
        let completeAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Done", handler: { (action: UITableViewRowAction!, indexPath:IndexPath!) -> Void in
            self.markCompletedTaskIn(indexPath)
        })
        
        // And a option to delete a task
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in self.deleteTaskIn(indexPath)
        })
        
        return [deleteAction, completeAction]

    }
 
 
    
    
    func markCompletedTaskIn(_ indexPath : IndexPath) {
        // To mark a task completed, retrieve the corresponding object from the cell index.
        let task = self.fetchedResultsController.object(at: indexPath)
        
        // Update the attribute
        task.isDone = true
        
        do {
            // And try to persist the change. If successful, the fetched results controller
            // will react and call the method to reload the table view.
            try self.managedObjectContext?.save()
        }catch{}
        
    }
    
    func deleteTaskIn(_ indexPath : IndexPath) {
        // To Delete a task, retrieve the corresponding object from the cell index.
        let task = self.fetchedResultsController.object(at: indexPath)
        
        // Then use the managed object context and delete that object.
        self.managedObjectContext?.delete(task)
        
        do {
            // And try to persist the change. If successful, the fetched results controller 
            // will react and call the method to reload the table view.
            try self.managedObjectContext?.save()
            
        }catch{}
    }

 

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        taskIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
  //      let detailToDo = Task[indexPath.row].toDo
        
    }

 }

