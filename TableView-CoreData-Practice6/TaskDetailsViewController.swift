//
//  TaskDetailsViewController.swift
//  TableView-CoreData-Practice6
//
//  Created by Tatsuya Moriguchi on 4/12/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData


class TaskDetailsViewController: UIViewController {

   @IBOutlet weak var toDoText: UITextField!
    @IBOutlet weak var isImpBool: UISwitch!
    @IBOutlet weak var isUrgBool: UISwitch!
    @IBOutlet weak var isDoneBool: UISwitch!
    @IBAction func backOnPressed(_ sender: Any) {
        performSegueToReturnBack() 
    }
    
   
    @IBAction func saveOnPressed(_ sender: Any) {
    
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
