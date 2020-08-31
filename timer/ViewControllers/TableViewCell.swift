//
//  TableViewCell.swift
//  timer
//
//  Created by Айсен Шишигин on 13/08/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import UIKit
import AVFoundation

class TableViewCell: UITableViewCell {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var timer = Timer()
    var isTimerRunning = false
    var counter = 10.0
    var counter2: Double!
    let timeManager = TimeManager()
    let audioManager = AudioManager()
    
    var isStarted: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        doneButton.isEnabled = false
        isStarted = false
    }
    
    func configure (task: Task) {
        
        taskNameLabel.text = task.name
        
        if !isStarted {
        counter = task.counter + 1.0
        runTimer()
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func playButtonPressed() {
        
        if !isStarted {
            if !isTimerRunning {
                timer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target: self,
                                              selector: #selector(runTimer),
                                              userInfo: nil,
                                              repeats: counter > 1)
                startButton.setImage(UIImage(named: "PauseButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
                isTimerRunning = true
                doneButton.isEnabled = true
                counter2 = counter
                isStarted = true
             }
        } else {
           pause()
        }
    }
    
    @IBAction func doneButtonPressed() {
        
        doneButton.isEnabled = true
        isTimerRunning = false
        timer.invalidate()
        contentView.backgroundColor = #colorLiteral(red: 1, green: 0.6936842203, blue: 0.2769840359, alpha: 1)
        timerLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        taskNameLabel.textColor = .darkGray
        timerLabel.text = "Success!"
        startButton.isHidden = true
        audioManager.startSuccessAudio()
    }
}

// MARK: - Extention

extension TableViewCell {
    
    func pause() {
        
        doneButton.isEnabled = true
        isTimerRunning = false
        timer.invalidate()
        isStarted = false
    }
    
     @objc func runTimer() {
        
        if counter > 1 {
                counter -= 0.1
        }

            // HH:MM:SS:_
        let flooredCounter = Int(floor(counter))
        let hour = flooredCounter / 3600

        let minute = (flooredCounter % 3600) / 60
        var minuteString = "\(minute)"
        if minute < 10 {
            minuteString = "0\(minute)"
        }

        let second = (flooredCounter % 3600) % 60
        var secondString = "\(second)"
        if second < 10 {
            secondString = "0\(second)"
        }

        timerLabel.text = "\(hour):\(minuteString):\(secondString)"
        setupFailScreen()
    }
    
    func setupFailScreen() {
        
        if counter < 1.0 {
            timerLabel.text = "Fail!"
            timerLabel.textColor = .red
            contentView.backgroundColor = .black
            doneButton.isHidden = true
            timer.invalidate()
            startButton.isHidden = true
            audioManager.startFailAudio()
        }
    }
}
