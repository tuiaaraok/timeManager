//
//  MainViewController.swift
//  timer
//
//  Created by Айсен Шишигин on 13/08/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import UIKit
import BonsaiController

var tasks: [Task] = []
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var emptyTaskLabel: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let task = tasks[indexPath.row]
        cell.configure(task: task)
        
        return cell
       }
    
    // MARK: - Table view delegate
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        tableView.reloadData()
        if tasks.count > 0 {
            emptyTaskLabel.isHidden = true
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            let newTaskVC = segue.destination as! NewTaskViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                newTaskVC.indexPath = indexPath
            }
        }
        if segue.destination is NewTaskViewController {
            segue.destination.transitioningDelegate = self
            segue.destination.modalPresentationStyle = .custom
        }
    }
}
