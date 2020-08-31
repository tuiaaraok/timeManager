//
//  Audio.swift
//  timer
//
//  Created by Айсен Шишигин on 30/08/2020.
//  Copyright © 2020 Туйаара Оконешникова. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {
    
    var audioPlayer: AVAudioPlayer!
    
    func setupAudioPlayer(name: String, type: String) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: name, ofType: type)!))
            audioPlayer.prepareToPlay()
               
            let audioSession = AVAudioSession.sharedInstance()
               
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            } catch {
                print(error)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func startSuccessAudio() {
        
        setupAudioPlayer(name: "success", type: "mp3")
        audioPlayer.play()
    }
       
    func startFailAudio() {
        
        setupAudioPlayer(name: "fail", type: "mp3")
        audioPlayer.play()
    }
}
