//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Gaddes on 22/11/2015.
//  Copyright © 2015 Matthew Gaddes. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    var durationOfRecording = 0.0
    
    // Playback buttons
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    
    // Playback labels
    @IBOutlet weak var slowLabel: UILabel!
    @IBOutlet weak var fastLabel: UILabel!
    @IBOutlet weak var chipmunkLabel: UILabel!
    @IBOutlet weak var darthVaderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create instance of AVAudioPlayer
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        // Store length of recording (in seconds)
        durationOfRecording = audioPlayer.duration
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Set title of PlaySoundsViewController
        self.title = "Playback"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        // Stop audio when "back" button is pressed
        stopPlayback()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playbackSlow(sender: UIButton) {
        
        // Stop current playback. This will also reset (enable) all buttons and labels
        stopPlayback()
        
        // Disable (grey out) button and label beneath
        sender.enabled = false
        slowLabel.enabled = false
        
        let slowPlayer = playbackSetup(audioPlayer)
        
        slowPlayer.rate = 0.5
        slowPlayer.play()
        
        // Enable label once playback has finished.
        // Duration of recording must be multiplied by 2, since the playback has been slowed and will take twice as long.
        delay(durationOfRecording * 2) {
            sender.enabled = true
            self.slowLabel.enabled = true
        }
    }
    
    @IBAction func playbackFast(sender: UIButton) {
        
        stopPlayback()
        
        sender.enabled = false
        fastLabel.enabled = false
        
        let fastPlayer = playbackSetup(audioPlayer)
        
        fastPlayer.rate = 2.0
        fastPlayer.play()
        
        delay(durationOfRecording / 2) {
            sender.enabled = true
            self.fastLabel.enabled = true
        }
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        stopPlayback()
        
        sender.enabled = false
        chipmunkLabel.enabled = false
        
        playAudioWithVariablePitch(1000)
        
        delay(durationOfRecording) {
            sender.enabled = true
            self.chipmunkLabel.enabled = true
        }
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        stopPlayback()
        
        sender.enabled = false
        darthVaderLabel.enabled = false
        
        playAudioWithVariablePitch(-1000)
        
        delay(durationOfRecording) {
            sender.enabled = true
            self.darthVaderLabel.enabled = true
        }
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        
        // When the "stop" button is pressed, call the function stopPlayback below
        stopPlayback()
    }
    
    // This function is identical to the one above, but it can be called from within another function (it does not rely on a UIButton press)
    func stopPlayback() {
        
        // Stop audio playback
        audioPlayer.stop()
        // This is required to stop both Chipmunk and Darth Vader audio (since they do not directly use audioPlayer()
        audioEngine.stop()
        resetPlaybackButtons()
    }
    
    // Use abstraction to cut down code in playbackSlow and playbackFast -> this new function holds reusable code
    func playbackSetup(player: AVAudioPlayer) -> AVAudioPlayer {
        
        player.stop()
        player.currentTime = 0
        player.prepareToPlay()
        
        return player
    }
    
    func resetPlaybackButtons() {
        
        // Reset buttons
        slowButton.enabled = true
        fastButton.enabled = true
        chipmunkButton.enabled = true
        darthVaderButton.enabled = true
        
        // Reset labels
        slowLabel.enabled = true
        fastLabel.enabled = true
        chipmunkLabel.enabled = true
        darthVaderLabel.enabled = true
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    // The delay() function has been taken from the StackOverflow page linked below
    // http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift
    // TODO: place this function in MODEL?
    // TODO: replace this function with NSTimer?
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
