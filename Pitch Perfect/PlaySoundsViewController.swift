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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create instance of AVAudioPlayer
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playbackSlow(sender: UIButton) {
        
        let slowPlayer = playbackSetup(audioPlayer)
        
        slowPlayer.rate = 0.5
        slowPlayer.play()
    }
    
    @IBAction func playbackFast(sender: UIButton) {
        
        let fastPlayer = playbackSetup(audioPlayer)
        
        fastPlayer.rate = 2.0
        fastPlayer.play()
    }

    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
    }
    
    // Use abstraction to cut down code in playbackSlow and playbackFast -> create a new function to hold duplicate code
    func playbackSetup(player: AVAudioPlayer) -> AVAudioPlayer {
        
        player.stop()
        player.currentTime = 0
        player.prepareToPlay()
        
        return player
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
