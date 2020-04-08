//
//  ViewController.swift
//  MC1.DetailTask
//
//  Created by Baskoro Indrayana on 04/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var focusMessageLabel: UILabel!
    @IBOutlet weak var distractionButton: UIButton!
    @IBOutlet weak var timesDistractedLabel: UILabel!
    @IBOutlet weak var playToggleButton: UIButton!
    
    var currentTask: Task?
    var musicService = MusicService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        focusMessageLabel.isHidden = true
        
        // 300 is width of circle fill in distraction button
        distractionButton.layer.cornerRadius = 300 / 2
        
        // set up countdown timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(onTimerFire),
                                              userInfo: nil, repeats: true)
    }
    
    // MARK: - countdown timer
    
    var countdownTimer: Timer?
    var secondsLeft: Int = 120 {
        didSet {
            // format to HH:MM:SS
            let hours: Int = secondsLeft / 3600
            let minutes: Int = (secondsLeft % 3600) / 60
            let seconds: Int = secondsLeft % 60
            
            if hours > 0 {
                timerLabel.text = String(format: "%02d:%02d:%02d",
                                         hours, minutes, seconds)
            } else {
                timerLabel.text = String(format: "%02d:%02d",
                                         minutes, seconds)
            }
        }
    }
    
    var timesDistracted: Int = 0 {
        didSet {
            timesDistractedLabel.text = String(timesDistracted)
            let fontSize = timesDistractedLabel.font.pointSize
            let increment = CGFloat(1)
            timesDistractedLabel.font =
                timesDistractedLabel.font.withSize(fontSize + increment)
            
            if timesDistracted == 3 {
                focusMessageLabel.isHidden = false
            }
        }
    }
    
    @objc func onTimerFire() {
        if countdownTimer == nil { return }
        
        secondsLeft -= 1
        if secondsLeft <= 0 {
            endCountdownTimer()
        }
    }
    
    func endCountdownTimer() {
        if let timer = countdownTimer {
            timer.invalidate()
            countdownTimer = nil
        }
    }
    
    // MARK: - distraction button

    @IBAction func distractionButtonTapped(_ sender: UIButton) {
        timesDistracted += 1
    }
    
    // MARK: - finish task
    
    @IBAction func finishTaskTapped(_ sender: UIButton) {
        // end timer if still exists
        endCountdownTimer()
        
        // stop music player
        musicService.stop()
        
        // submit data, ALSO with remaining seconds (for progress report)
        
        
        // after submitted -> reset seconds left to 0 for timer label
        secondsLeft = 0
    }
    
    // MARK: - select from music library
    
    @IBAction func libraryButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: Identifiers.Segues.toMusicLibrary,
                     sender: self)
    }
    
    @IBAction func unwindAfterSelectSong(_ unwindSegue: UIStoryboardSegue) {
        if let libraryVC = unwindSegue.source as? MusicLibraryViewController {
            // Use data from the view controller which initiated the unwind segue
            if let song = libraryVC.selectedSongTitle {
//                print(song)

                musicService.play(title: song)
            }
        }
    }
    
    // play as in play/pause *toggle*, NOT selecting music (which is already
    // configured from `libraryButtonTapped(...)` above
    @IBAction func playMusicTapped(_ sender: UIButton) {
        musicService.togglePlayback()
//        if musicService.isPlaying {
//            playToggleButton.imageView?.image = UIImage(named: Identifiers.Assets.pauseButton)
//        } else {
//            playToggleButton.imageView?.image = UIImage(named: Identifiers.Assets.playButton)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let libraryVC = segue.destination as? MusicLibraryViewController {
            libraryVC.musicService = self.musicService
        }
    }
}

