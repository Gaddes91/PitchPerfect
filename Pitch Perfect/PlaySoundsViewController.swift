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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filePath = NSBundle.mainBundle().URLForResource("movie_quote", withExtension: "mp3") {
            
            // Create instance of AVAudioPlayer
            audioPlayer = try! AVAudioPlayer(contentsOfURL: filePath)
            audioPlayer.enableRate = true
            
        } else { print("Filepath not found.") }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playbackSlow(sender: UIButton) {
        // Play audio sloooowly here...
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.prepareToPlay()
        
        audioPlayer.play()
    }
    
    @IBAction func playbackFast(sender: UIButton) {
        // Play audio quickly here...
        audioPlayer.stop()
        audioPlayer.rate = 2.0
        audioPlayer.prepareToPlay()
        
        audioPlayer.play()      
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
