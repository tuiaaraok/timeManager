//
//  NewTaskVCExtention.swift
//  timer
//
//  Created by Айсен Шишигин on 12/09/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import UIKit

extension NewTaskViewController {
    
    // MARK: - Configure UIViews

    func configureButtons() {
        
        cancelButton.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysOriginal), for: .normal)
        saveButton.setImage(UIImage(named: "DoneButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
              
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
    }
    
    func configureTextFeld() {
        
        textField.becomeFirstResponder()
        textField.backgroundColor = #colorLiteral(red: 1, green: 0.6936842203, blue: 0.2769840359, alpha: 1)
        textField.placeholder = "Напишите задание"
        textField.borderStyle = .roundedRect
    }
    
    // MARK: - Objc methods
    
    @objc func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc func saveButtonPressed(_ sender: Any) {
          
        if indexPath != nil {
            dataManager.edit(textField.text!, counter: Double(counter), indexPath: indexPath)
        } else {
            dataManager.save(textField.text!, counter: Double(counter), mainVC.tableView)
        }
          
        mainVC.updateScreen()
        NotificationCenter.default.post(name: .reload, object: nil)
        dismiss(animated: true)
    }
      
    @objc func textFieldChanged() {
          
        if textField.text?.isEmpty == false  {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
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

extension Notification.Name {
    static let reload = Notification.Name("reload")
}
