//
//  TimeManager.swift
//  timer
//
//  Created by Айсен Шишигин on 29/08/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import UIKit
class TimeManager {

    func getHoursAndMinutes() -> Int {
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        return hour + minutes + seconds
    }
    
    

}
