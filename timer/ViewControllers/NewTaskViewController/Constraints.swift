//
//  Constraints.swift
//  timer
//
//  Created by Айсен Шишигин on 12/09/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import Foundation

extension NewTaskViewController {
    
    func createConstraints() {
              
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/6) .isActive = true
              
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -40).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
              
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/6).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 40).isActive = true
              
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
        saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/11).isActive = true
        saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
    }
}
