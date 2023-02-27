//
//  ViewController.swift
//  AVFoundation
//
//  Created by 라완 💕 on 23/05/1444 AH.
//

import UIKit
import Foundation
import AVFoundation
import SpriteKit
import SCLAlertView
import BAFluidView
import AVFAudio

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    
    var doubleTabActive =  false
    var fluidView: BAFluidView!
    var startedFluidView: BAFluidView!
    var player: AVAudioPlayer?
    var playerr: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBAFluidView()
        view.addSubview(fluidView)
        view.addSubview(startedFluidView)
        view.sendSubviewToBack(fluidView)
        view.sendSubviewToBack(startedFluidView)
        settingAudioData()
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        guard let player = player else { return }
        slider.maximumValue = Float(player.duration)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(sliderTrackingFunctionality), userInfo: nil, repeats: true)
    }
    
    func settingAudioData() {
        let urlString = Bundle.main.path(forResource: "Cloud-Instrumental", ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let urlString = urlString else { return }
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
        }catch {
            print("Somthing Wrong")
        }
        
    }
    
    @IBAction func startPauseButton(_ sender: UIButton) {
        startPauseFunctionality()
    }
    
    func startPauseFunctionality() {
        if let player = player, player.isPlaying {
            player.pause()
            fluidView.isHidden = false
            startedFluidView.isHidden = true
        }else {
            guard let player = player else { return }
            player.play()
            fluidView.isHidden = true
            startedFluidView.isHidden = false
        }
    }
    
    @IBAction func showAlert(_ sender: UIBarButtonItem) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Got it") {
            print("Got it tapped")
        }
        
        alert.showInfo("Tap Screen", subTitle: "double tap or triple tap on the screen for more!\n\n (double tab) \n •relaxing ocean sound  \n\n This app for practicing breathing and relaxation",
                       colorStyle: 0x635297)
        
    }
    
    @IBAction func trackingSliderController(_ sender: UISlider) {
        if let player = player, player.isPlaying {
            player.stop()
            player.currentTime = TimeInterval(slider.value)
            player.prepareToPlay()
            player.play()
        }else {
            guard let player = player else { return }
            player.currentTime = TimeInterval(slider.value)
        }
    }
    
    func createBAFluidView() {
        fluidView = BAFluidView(frame: self.view.frame, startElevation: NSNumber(0.05))
       
        startedFluidView = BAFluidView(frame: self.view.frame, startElevation: NSNumber(0.05))
        fluidView.fillColor = UIColorFromRGB(0x635297)
        startedFluidView.fillColor = UIColorFromRGB(0x635297)
        startedFluidView.fillDuration = 30.0
        fluidView.fill(to: NSNumber(value: 0.05))
        startedFluidView.fill(to: NSNumber(value: 0.5))
        fluidView.startAnimation()
        startedFluidView.startAnimation()
        startedFluidView.isHidden = true
    }
    
    @objc func sliderTrackingFunctionality() {
        guard let player = player else { return }
        slider.value = Float(player.currentTime)
    }
    
    @objc func handleDoubleTap() {
        if doubleTabActive == false {
            doubleTabActive = true
            let urlString = Bundle.main.path(forResource: "ocean waves", ofType: "mp3")
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                guard let urlString = urlString else { return }
                playerr = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            }catch {
                print("Somthing Went Wrong")
            }
            playerr?.play()
            print("play")
        }else {
            doubleTabActive = false
            playerr?.pause()
            print("pause")
        }
    }
}



