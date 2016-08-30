//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Terrence Kuo on 1/26/16.
//  Copyright (c) 2016 terrencekuo. All rights reserved.
//

import UIKit        // import class for standard UI
import AVFoundation // import class for audio

// added the <AVAudioRecorderDelegate> to delegate the class to the RecordSoundViewController
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio! // create instance of our MODEL

    // intial setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // show/hide buttons
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function called when the recordButton is pressed
    @IBAction func recordButton(sender: UIButton) {
        // Display text
        recordingInProgress.hidden = false; // recordingInProgress is an Outlet text defined above
        // TODO: Record audio
        
        // prevent record Button from being pressed twice
        recordButton.enabled = false; // recordButton is an Outlet image defined above
        // show stop button
        stopButton.hidden = false; // stop button is an Outlet image defined above
        
        // setup file name and location to be saved
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // setup the audio session
        let session = AVAudioSession.sharedInstance() // give app access to microphone/speaker hardware
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        // allow sound to be played on the loud speaker
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch _ {
        }
        
        // initialize and prepare the recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self // required for delegating
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // function called when the stopButton is pressed
    @IBAction func stopButton(sender: UIButton) {
        // Hide text
        recordingInProgress.hidden = true;
        
        // re-enable Button
        recordButton.enabled = true;
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
    
    // this is called after the stop button which is when the recording stops
    // the parameters are <recorder> and <flag>
    // the colon (:) followed by a name denotes the type of the parameter
    // function from delegate Protocol
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            // save the recorded audio
            recordedAudio = RecordedAudio();
            recordedAudio.filepathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // move to next scene - segue
            // "stopRecording" is the name of the segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            print("error recording");
        }
    }
    
    // function called right before Segue is called
    // good for passing data to other controller
    // this is called after all the other functions and used to transition from one controller to another
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // necessary incase we have mutiple segue
        if (segue.identifier == "stopRecording"){ // "stopRecording" is the name of the segue
            // create a variable <playSoundsVC> of type PlaySoundsViewController which is the destination scene
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            // sender is the object that initiated the segue. retrieve the data 
            let data = sender as! RecordedAudio
            
            // send data to second screen by setting the variable recievedAudio in the PlaySoundsViewControllerClass
            playSoundsVC.recievedAudio = data 
        }
    }
    

    

    
}

