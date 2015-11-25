//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Gaddes on 21/11/2015.
//  Copyright © 2015 Matthew Gaddes. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingEllipsis: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    // Initialise timer to be used for ellipsis animation
    var timer = NSTimer()
    var arrayIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        recordingEllipsis.hidden = true
        stopButton.hidden = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        // Disable record button
        recordButton.enabled = false
        // Show stop button
        stopButton.hidden = false
        // Show text "recording in progress"
        recordingLabel.text = "Recording in progress"
        // Show ellipsis
        recordingEllipsis.hidden = false
        
        // Start timer - animate ellipsis
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("pulseRecordingLabel"), userInfo: nil, repeats: true)
        
        // Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {

        if (flag) {
            
            // Step 1 - Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // Step 2 - Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // This code is executed just before a segue is performed
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        // Invalidate timer - stop animating ellipsis
        timer.invalidate()
        // Revert text label
        recordingLabel.text = "Tap to record"
        // Hide ellipsis
        recordingEllipsis.hidden = true
        // Hide stop button
        stopButton.hidden = true
        // Show record button
        recordButton.enabled = true
        
        // Stop audio from recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    // Function for use with timer
    func pulseRecordingLabel() {
        
        let array = [".", "..", "...", ""]
        
        // Ensure counter does not go "out of bounds"
        if arrayIndex >= array.count {
            arrayIndex = 0
        } else {
            // Update label text
            self.recordingEllipsis.text = array[arrayIndex]
            
            // Increment counter
            ++arrayIndex
        }
    }
}

