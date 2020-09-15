//
//  TableViewCell.swift
//  timer
//
//  Created by Айсен Шишигин on 13/08/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class TableViewCell: UITableViewCell {

    let startButton = UIButton()
    let doneButton = UIButton()
    let timerLabel = UILabel()
    let taskNameLabel = UILabel()
    
    var timer = Timer()
    var isTimerRunning = false
    var counter = 10.0
    let audioManager = AudioManager()
    let dataManager = DataManager()
    
    var isStarted: Bool = false
    var indexPath: IndexPath!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(timerLabel)
        addSubview(taskNameLabel)
        addSubview(startButton)
        addSubview(doneButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        doneButton.isEnabled = false
        isStarted = false
    }
    
    func configure (_ task: NSManagedObject, _ indexPath: IndexPath) {
        
        createConstraints()
        configureLabels()
        configureButtons()
        
        contentView.backgroundColor = #colorLiteral(red: 0.1888155764, green: 0.1888155764, blue: 0.1888155764, alpha: 1)
        taskNameLabel.text = task.value(forKey: "name") as? String
        self.indexPath = indexPath
        
        if !isStarted {
            counter = (task.value(forKey: "counter") as? Double)! + 1
            runTimer()
        }
       
        startButton.isHidden = false
        startButton.isEnabled = true
        doneButton.isEnabled = false
     
        if task.value(forKey: "status") as? String == "success" {
            setupSuccessScreen()
        } else if task.value(forKey: "status") as? String == "fail" {
            setupFailScreen()
        }
    }
    
    @objc func startButtonPressed() {
        
        if !isStarted {
            doneButton.isEnabled = true
            if !isTimerRunning {
                timer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target: self,
                                              selector: #selector(runTimer),
                                              userInfo: nil,
                                              repeats: counter > 1)
                startButton.setImage(UIImage(named: "PauseButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
                isTimerRunning = true
                isStarted = true
            } 
        } else {
            pause()
            startButton.setImage(UIImage(named: "PlayButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc func doneButtonPressed() {
        
        setupSuccessScreen()
        audioManager.startSuccessAudio()
        isStarted = false
        dataManager.setupStatus(text: "success", indexPath: indexPath)
        startButton.setImage(UIImage(named: "PauseButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    @objc func runTimer() {
         
         if counter > 1 {
             counter -= 0.1
         }
     
         configureTimerLAbelText()
     }
    
    // MARK: - Configure UIVIews
    
    func configureLabels() {
        
        timerLabel.textColor = #colorLiteral(red: 1, green: 0.6936842203, blue: 0.2769840359, alpha: 1)
        taskNameLabel.textColor = #colorLiteral(red: 1, green: 0.6936842203, blue: 0.2769840359, alpha: 1)
        
        timerLabel.font = UIFont(name: "Futura-Medium", size: 18)
        taskNameLabel.font = UIFont(name: "Futura-Medium", size: 15)
        
        timerLabel.minimumScaleFactor = -0.5
        taskNameLabel.minimumScaleFactor = -0.5
        
        timerLabel.numberOfLines = 1
        taskNameLabel.numberOfLines = 0
        
        timerLabel.textAlignment = .center
    }
    
    func configureButtons() {
        
        startButton.setImage(UIImage(named: "PlayButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        doneButton.setImage(UIImage(named: "DoneButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }
}

// MARK: - Extension

extension TableViewCell {
    
//    func refreshCell() {
//        
//        contentView.backgroundColor = .darkGray
//        timerLabel.textColor = #colorLiteral(red: 1, green: 0.6936842203, blue: 0.2769840359, alpha: 1)
//        taskNameLabel.textColor = .darkGray
//    }
    
    func pause() {

        doneButton.isEnabled = false
        isTimerRunning = false
        timer.invalidate()
        isStarted = false
    }
    
    private func configureTimerLAbelText() {
        
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
               
        var hourString = "\(hour)"
        if hour < 10 {
            hourString = "0\(hour)"
        }

        timerLabel.text = "\(hourString):\(minuteString):\(secondString)"
               
        if counter < 1.0 {
            setupFailScreen()
            dataManager.setupStatus(text: "fail", indexPath: indexPath)
            audioManager.startFailAudio()
        }
    }
    
    private func setupFailScreen() {
        
        timerLabel.text = "Fail!"
        timerLabel.textColor = .red
        contentView.backgroundColor = .black
        doneButton.isHidden = true
        timer.invalidate()
        startButton.isHidden = true
    }
    
    private func setupSuccessScreen() {
        
        isTimerRunning = false
        timer.invalidate()
        contentView.backgroundColor = #colorLiteral(red: 1, green: 0.6936842203, blue: 0.2769840359, alpha: 1)
        timerLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        taskNameLabel.textColor = .darkGray
        timerLabel.text = "Success!"
        startButton.isHidden = true
    }
    
    private func createConstraints() {
        
        let screenSize = UIScreen.main.bounds
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant:
                   screenSize.width > 500 ? screenSize.width / 17 : screenSize.width / 12
                   ).isActive = true
        doneButton.heightAnchor.constraint(equalTo: doneButton.widthAnchor).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        doneButton.clipsToBounds = true
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -5).isActive = true
        startButton.widthAnchor.constraint(equalToConstant:
            screenSize.width > 500 ? screenSize.width / 17 : screenSize.width / 12
        ).isActive = true
        startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        taskNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        taskNameLabel.widthAnchor.constraint(equalToConstant: screenSize.width / 2.1).isActive = true
        taskNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 7/10).isActive = true
        taskNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        taskNameLabel.trailingAnchor.constraint(equalTo: timerLabel.leadingAnchor, constant: -15).isActive = true
      
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant: screenSize.width / 4.5).isActive = true
        timerLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo: startButton.leadingAnchor, constant: -7).isActive = true
    }
}
