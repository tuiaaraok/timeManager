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

class MainViewController: UITableViewController {
   
    private let emptyTaskLabel = UILabel()
    
    var timerToReset: Timer!
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1888155764, green: 0.1888155764, blue: 0.1888155764, alpha: 1)
    
        tableView.rowHeight = 80
        
        configureTimerToReset()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataManager.fetchData()
        
        if tableView.numberOfRows(inSection: 0) > 0 {
            emptyTaskLabel.isHidden = true
        }
    }
    
    func configureTimerToReset() {
        
        self.timerToReset = Timer(timeInterval: 1,
                             target: self,
                             selector: #selector(refresh),
                             userInfo: nil,
                             repeats: true)
               
        RunLoop.main.add(self.timerToReset, forMode: .default)
               
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableData),
                                               name: .reload,
                                               object: nil)
    }
    
    // MARK: - Objc methods
    
    @objc func reloadTableData(_ notification: Notification) {
          tableView.reloadData()
      }
    
    @objc func refresh() {
        
        if dataManager.getHoursAndMinutes() == 0 {
            
            for task in tasks {
                    task.setValue("none", forKey: "status")
            }
        
            do {
                try dataManager.managedContext.save()
                tableView.reloadData()
            } catch let error {
                print("Failed to reset task", error.localizedDescription)
            }
            
            UserDefaults.standard.set(Date(), forKey: "lastRefresh")
            
        }
    }
    
  @objc func addButtonTapped() {
        
        let nextScreen = NewTaskViewController()
        nextScreen.transitioningDelegate = self
        nextScreen.modalPresentationStyle = .custom
        navigationController?.present(nextScreen, animated: true)
    }
    
    private func setupNavigationBar() {
        
        title = "Задания"
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.6936842203, blue: 0.2769840359, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(#colorLiteral(red: 1, green: 0.6936842203, blue: 0.2769840359, alpha: 1)), .font: UIFont(name: "Futura-Medium", size: 25)!]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(#colorLiteral(red: 0.1888155764, green: 0.1888155764, blue: 0.1888155764, alpha: 1))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }
    
    func updateScreen() {

        if tableView.numberOfRows(inSection: 0) > 0 {
            emptyTaskLabel.isHidden = true
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewCell()
        let task = tasks[indexPath.row]
        cell.configure(task, indexPath)
        
        return cell
    }
    
    // MARK: - Table view delegate
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newTaskVC = NewTaskViewController()
        newTaskVC.transitioningDelegate = self
        newTaskVC.modalPresentationStyle = .custom
        newTaskVC.indexPath = indexPath
        present(newTaskVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

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
}
