//
//  ViewController.swift
//  timer
//
//  Created by Айсен Шишигин on 13/08/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController {

    var pickerView = UIPickerView()
    var textField = UITextField()
    var cancelButton = UIButton()
    var saveButton = UIButton()
    
    var hour: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    var counter = 0
    var indexPath: IndexPath!
    let dataManager = DataManager()
    let mainVC = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.delegate = self
  
        saveButton.isEnabled = false
        
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        setupScreen()
    }
    
    private func setupScreen() {
        
        view.backgroundColor = #colorLiteral(red: 0.1888155764, green: 0.1888155764, blue: 0.1888155764, alpha: 1)
        view.addSubview(pickerView)
        view.addSubview(textField)
        
        if indexPath != nil {
            counter = Int((tasks[indexPath.row].value(forKey: "counter") as? Double)!)
            textField.text = (tasks[indexPath.row].value(forKey: "name") as? String)!
            hour = counter / 3600
            pickerView.selectRow(hour, inComponent: 0, animated: true)
            minutes = (counter % 3600) / 60
            pickerView.selectRow(minutes, inComponent: 1, animated: true)
            seconds = (counter % 3600) % 60
            pickerView.selectRow(seconds, inComponent: 2, animated: true)
            saveButton.isEnabled = true
        }
                 
        configureButtons()
        configureTextFeld()
        createConstraints()
    }
} 
