//
//  ViewController.swift
//  BullsEye
//
//  Created by luan on 5/31/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentValue: Int = 0
    var targetValue: Int = 0
    var scores: Int = 0
    var round: Int = 0
    @IBOutlet var slider: UISlider!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var roundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startNewGame()
        updateLabels()
        
        let thumbNormalIcon = UIImage(named: "SliderThumb-Normal")
        slider.setThumbImage(thumbNormalIcon, forState: .Normal)
        
        let thumbHighlightIcon = UIImage(named: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbHighlightIcon, forState: .Highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        if let trackLeft = UIImage(named: "SliderTrackLeft") {
            let trackLeftReziable = trackLeft.resizableImageWithCapInsets(insets)
            slider.setMinimumTrackImage(trackLeftReziable, forState: .Normal)
        }
        
        if let trackRight = UIImage(named: "SliderTrackRight") {
            let trackRightReziable = trackRight.resizableImageWithCapInsets(insets)
            slider.setMaximumTrackImage(trackRightReziable, forState: .Normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        
        let differentValue = abs(currentValue - targetValue)
        var points = 100 - differentValue
        
        var title: String
        if differentValue == 0 {
            title = "Perfect!"
            points += 100
        }
        else if differentValue < 5 {
            title = "You almost had it!"
            if differentValue == 1 {
                points += 50
            }
        }
        else if differentValue < 10 {
            title = "Pretty good!"
        }
        else {
            title = "Not even close!"
        }
        
        let message = "You scored \(points) points"
        
        scores += points
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: {
            action in
            self.startNewRound()
            self.updateLabels()
            })
        
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(slider: UISlider) {
        currentValue = lroundf(slider.value)
        print("The value of slider is now \(slider.value)")
    }
    
    func startNewRound() {
        targetValue = 1 + Int(arc4random_uniform(100))
        
        slider.value = 50
        currentValue = lroundf(slider.value)
        
        round += 1
    }
    
    @IBAction func startOver() {
        startNewGame()
        updateLabels()
    }
    
    func startNewGame() {
        scores = 0
        round = 0
        
        startNewRound()
    }
    
    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(scores)
        roundLabel.text = String(round)
    }
}

