//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Gaddes on 21/11/2015.
//  Copyright © 2015 Matthew Gaddes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        // Disable record button
        recordButton.enabled = false
        // Show stop button
        stopButton.hidden = false
        // Show text "recording in progress"
        recordingLabel.hidden = false
        // TODO: Record the user's voice
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        // Stop audio from playing
        recordingLabel.hidden = true
        // Hide stop button
        stopButton.hidden = true
        // Show record button
        recordButton.enabled = true
    }
    
}

