//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Terrence Kuo on 1/26/16.
//  Copyright (c) 2016 terrencekuo. All rights reserved.
//

import UIKit
import AVFoundation // used for the audioPlayer

class PlaySoundsViewController: UIViewController {
    
    // variables
    var audioPlayer:AVAudioPlayer!    // variable audioPlayer is of type AVAudioPlayer
    var recievedAudio: RecordedAudio! // variable recievedAudio is of type RecordedAudio, contains data from RecordSoundsController
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    // lifecycle functions
    // init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // obtain filepath
        //if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
        // convert filepath to NSURL
        //var fileURL = NSURL.fileURLWithPath(filePath);
        
        // obtain file of the recorded audio
        audioPlayer = try? AVAudioPlayer(contentsOfURL: recievedAudio.filepathUrl)
        audioPlayer.enableRate = true;
        
        // setup class for changing pitch
        audioEngine = AVAudioEngine();
        
        // setup class for getting audioFileFormat
        audioFile = try? AVAudioFile(forReading: recievedAudio.filepathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // functions
    @IBAction func playSlow(sender: UIButton) {
        // Play sound
        audioPlayer.stop();
        audioPlayer.rate = 0.5;
        audioPlayer.currentTime = 0.0;
        audioPlayer.play();
    }
    
    @IBAction func playFast(sender: UIButton) {
        // Play sound
        audioPlayer.stop();
        audioPlayer.rate = 1.5;
        audioPlayer.currentTime = 0.0;
        audioPlayer.play();
    }

    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playVadar(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        // stop all audio
        audioPlayer.stop();
        audioEngine.stop();
        audioEngine.reset();
        
        // play audio
        let pitchPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(pitchPlayer)
        
        // change pitch
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        
        // conect the audio player to the pitch modifer
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        
        // connect the pitch modifer to the speaker, aka output
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        // play the audio using the pitch player
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)

        try! audioEngine.start()
        pitchPlayer.play()
    }

    @IBAction func stopSound(sender: UIButton) {
        audioPlayer.stop();
    }
}
