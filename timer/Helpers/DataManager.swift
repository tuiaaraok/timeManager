//
//  DataManager.swift
//  timer
//
//  Created by Айсен Шишигин on 04/09/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(_ taskName: String, counter: Double, _ tableView: UITableView) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task",
                                                      in: managedContext) else { return }
        let task = NSManagedObject(entity: entity,
                                   insertInto: managedContext) as! Task
        task.name = taskName
        task.counter = counter
        task.status = ""
        
        do {
            try managedContext.save()
            tasks.append(task)
            tableView.insertRows(
                at: [IndexPath(row: tasks.count - 1, section: 0)],
                with: .automatic
            )
            
        } catch let error {
            print("Failed to save task", error.localizedDescription)
        }
    }
    
    func edit(_ taskName: String, counter: Double, indexPath: IndexPath) {
        
        let task = tasks[indexPath.row]
        task.setValue(taskName, forKey: "name")
        task.setValue(counter, forKey: "counter")
            
        do {
            try managedContext.save()
            
        } catch let error {
            print("Failed to save task", error.localizedDescription)
        }
    }
    
    func setupStatus(text: String, indexPath: IndexPath) {
          
        let task = tasks[indexPath.row]
        task.setValue(text, forKey: "status")
                
        do {
            try managedContext.save()
        } catch let error {
            print("Failed to save task", error.localizedDescription)
        }
    }
    
    func getHoursAndMinutes() -> Int {
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        return hour + minutes + seconds 
    }
    
    func fetchData() {
           
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

