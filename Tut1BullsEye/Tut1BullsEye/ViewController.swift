//
//  ViewController.swift
//  Tut1BullsEye
//
//  Created by luan on 5/24/16.
//  Copyright © 2016 luxu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentValue = 0
    var targetValue = 0
    var score = 0
    var round = 0
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
        updateLabels()
        
        let thumbNormal = UIImage(named: "SliderThumb-Normal")
        slider.setThumbImage(thumbNormal, forState: .Normal)
        
        let thumbHighlighted = UIImage(named: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbHighlighted, forState: .Highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
            let trackLeftResize = trackLeftImage.resizableImageWithCapInsets(insets)
            slider.setMinimumTrackImage(trackLeftResize, forState: .Normal)
        }
        
        if let trackRightImage = UIImage(named: "SliderTrackRight") {
            let trackRightResize = trackRightImage.resizableImageWithCapInsets(insets)
            
            slider.setMaximumTrackImage(trackRightResize, forState: .Normal)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showAlert() {
        let differentValue = abs(targetValue - currentValue)
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
            title = "Not event close!"
        }
        
        let message = "You scored \(points) points"
        let alert = UIAlertController(title: title,
            message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Ok", style: .Default, handler: {
            action in
            self.startNewRound()
            self.updateLabels()
        })
        alert.addAction(action)
        
        score += points
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    func startNewRound() {
        targetValue = 1 + Int(arc4random_uniform(100))
        round++
        currentValue = 50
        slider.value = Float(currentValue)
    }
    
    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
    
    func startNewGame() {
        score = 0
        round = 0
        startNewRound()
    }
    
    @IBAction func startOver() {
        startNewGame()
        updateLabels()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        view.layer.addAnimation(transition, forKey: nil)
    }
}

