//
//  Player.swift
//  Recordings-MVC
//
//  Created by zhaoke on 2019/5/28.
//  Copyright © 2019 hjkl. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class Player: NSObject, AVAudioPlayerDelegate {
    
    private var audioPlayer: AVAudioPlayer
    private var timer: Timer?
    private var update: (TimeInterval?) -> ()
    
    init?(url: URL, update: @escaping (TimeInterval?) -> ()) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            return nil
        }
        
        if let player = try? AVAudioPlayer(contentsOf: url) {
            audioPlayer = player
            self.update = update
        } else {
            return nil
        }
        super.init()
        audioPlayer.delegate = self
    }
    
    func togglePlay() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            timer?.invalidate()
            timer = nil
        } else {
            audioPlayer.play()
            if let t = timer {
                t.invalidate()
            }
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                guard let s = self else { return }
                s.update(s.audioPlayer.currentTime)
            }
        }
    }
    
    func setProgress(_ time: TimeInterval) {
        audioPlayer.currentTime = time
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
        timer = nil
        update(flag ? audioPlayer.currentTime : nil)
    }
    
    var duration: TimeInterval {
        return audioPlayer.duration
    }
    
    var isPaused: Bool {
        return !audioPlayer.isPlaying && audioPlayer.currentTime > 0
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
