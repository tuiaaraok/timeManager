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

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var hour:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    var counter = 0
    var indexPath: IndexPath!
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        saveButton.isEnabled = false
        
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupScreen()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        if indexPath != nil {
            dataManager.edit(textField.text!, counter: Double(counter), indexPath: indexPath)
        } else {
            dataManager.save(textField.text!, counter: Double(counter))
        }
    }
    
    @objc func textFieldChanged() {
        
        if textField.text?.isEmpty == false  {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    private func setupScreen() {
        
        textField.becomeFirstResponder()
        
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
                 
        cancelButton.layer.cornerRadius = cancelButton.frame.width / 2
        saveButton.layer.cornerRadius = saveButton.frame.width / 2
    }
} 

extension NewTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        switch component {
        case 0:
            return 25
        case 1,2:
            return 60
        default:
            return 0
        }
    }
    
    // MARK: - Picker view delegate

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return "\(row) h"
        case 1:
            return "\(row) min"
        case 2:
            return "\(row) sec"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
        case 1:
            minutes = row
        case 2:
            seconds = row
        default:
            break;
        }
        
        counter = (hour * 60 * 60) + (minutes * 60) + seconds 
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let title = UILabel()
        title.font = UIFont(name: "Futura-Medium", size: 24)
        title.textColor = #colorLiteral(red: 1, green: 0.6936842203, blue: 0.2769840359, alpha: 1)
        title.textAlignment = .center
        
        switch component {
            case 0:
                title.text = "\(row) h"
            case 1:
                title.text = "\(row) min"
            case 2:
                title.text = "\(row) sec"
            default:
                title.text = ""
            }
        return title
    }
}

// MARK: - UITextFieldDelegate

extension NewTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
}
