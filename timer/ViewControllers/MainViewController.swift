//
//  MainViewController.swift
//  timer
//
//  Created by Айсен Шишигин on 13/08/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import UIKit
import BonsaiController
import CoreData

var tasks: [NSManagedObject] = []


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var emptyTaskLabel: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var myTimer: Timer!
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.myTimer = Timer(timeInterval: 50, target: self, selector: #selector(reset), userInfo: nil, repeats: true)
        RunLoop.main.add(self.myTimer, forMode: .default)
      
        tableView.rowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       fetchData()
        
        if tableView.numberOfRows(inSection: 0) > 0 {
            emptyTaskLabel.isHidden = true
        }
    }
    
    @objc func reset() {

        for task in tasks {
            task.setValue("none", forKey: "status")
        }
    
        do {
            try dataManager.managedContext.save()
            tableView.reloadData()
        } catch let error {
            print("Failed to reset task", error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return tasks.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let task = tasks[indexPath.row]
        cell.configure(task, indexPath)
        
        return cell
    }
    
    // MARK: - Table view delegate
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if tasks.count > indexPath.row {
            let task = tasks[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(task)
            tasks.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch let error {
                print("Не удалось сохранить из-за ошибки \(error).")
            }
            tableView.deleteRows(at:[indexPath],with: .fade)
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        tableView.reloadData()
        
        if tableView.numberOfRows(inSection: 0) > 0 {
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
    
    private func fetchData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
                    
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Не могу прочитать. \(error), \(error.userInfo)")
        }
    }
}
