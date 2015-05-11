//
//  MoodInputViewController.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 4/28/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import UIKit


class MoodInputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: Properties

    // MARK: IBOutlets
    @IBOutlet var leftThumbImageView: UIImageView!;
    @IBOutlet var moodLevelLabel: UILabel!;

    @IBOutlet var explanationLabel: UILabel!;
    @IBOutlet var recordButton: UIButton!;
    @IBOutlet var moodRecordedLabel: UILabel!;

    @IBOutlet var energyLevelPicker: UIPickerView!;

    // MARK: State
    var thumbNumber: Int!, thumbFileName: String!;
    var currentMood: Mood = .Ok
    var currentEnergyLevel: EnergyLevel = .Average

    var currentTouchLocation: CGPoint?;

    // MARK: Parameters
    let movementThreshold = 8;
    let minThumbNumber = 1;
    let maxThumbNumber = 15;

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        thumbNumber = 7;
        updateFileName();

        self.view.addSubview(leftThumbImageView);
        leftThumbImageView.frame = self.view.frame;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        self.recordButton.hidden = true;
        self.explanationLabel.hidden = false;
        self.moodRecordedLabel.hidden = true;

        let recentMood: MoodState? = DataStore.sharedDataStore.getMostRecentMood();
        if (recentMood != nil) {
            self.currentEnergyLevel = recentMood!.energyLevel
            self.currentMood = recentMood!.mood;
        }
        else {
            self.currentEnergyLevel = .Average;
            self.currentMood = .Ok
        }
        self.energyLevelPicker.selectRow(self.currentEnergyLevel.rawValue, inComponent: 0, animated: false);

        switch (self.currentMood) {
        case .Euphoric:
            thumbNumber = 1;
        case .Great:
            thumbNumber = 2;
        case .Good:
            thumbNumber = 4;
        case .Ok:
            thumbNumber = 7;
        case .Bad:
            thumbNumber = 10;
        case .ReallyBad:
            thumbNumber = 13;
        case .Depressed:
            thumbNumber = 15;
        }
        updateFileName();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBActions
    @IBAction func saveMood() {
        DataStore.sharedDataStore.recordMood(currentMood, energyLevel: currentEnergyLevel);
        self.recordButton.hidden = true;
        self.moodRecordedLabel.hidden = false;
    }

    // MARK: Touch Handling

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)

        let possibleTouch = touches.first as? UITouch

        if let touch = possibleTouch {
            let touchLoc = touch.locationInView(self.leftThumbImageView);
            if (touchLoc.x >= 0.0 && touchLoc.x <= leftThumbImageView.frameWidth
                && touchLoc.y >= 0.0 && touchLoc.y <= leftThumbImageView.frameHeight) {
                    self.currentTouchLocation = touch.locationInView(self.view);
            }
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event);

        self.currentTouchLocation = nil;
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event);
        if currentTouchLocation == nil {
            return;
        }
        let possibleTouch = touches.first as? UITouch;
        if let touch = possibleTouch {
            let yDisplacement: Int! = Int(touch.locationInView(self.view).y - currentTouchLocation!.y);
            if Int(abs(yDisplacement)) > movementThreshold {
                let movementDirection: Int! = (yDisplacement < 0) ? -1 : 1;
                if ((movementDirection == 1 && self.thumbNumber < maxThumbNumber)
                    || (movementDirection == -1 && self.thumbNumber > minThumbNumber)) {
                        self.thumbNumber = self.thumbNumber + movementDirection;
                }
                let touchX = currentTouchLocation!.x;
                let touchY = currentTouchLocation!.y + CGFloat(yDisplacement);
                let newTouchLocation = CGPoint(x: touchX, y: touchY);
                self.currentTouchLocation = newTouchLocation;

                self.updateFileName();
            }
        }
    }


    // MARK: UIPickerViewDelegate, UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EnergyLevel.count;
    }

    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var returnString = EnergyLevelStrings[row];

        return NSAttributedString(string: returnString);
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentEnergyLevel = EnergyLevel(rawValue: row)!;
    }

    // MARK: Helpers

    func updateFileName() {
        var numberString = String(thumbNumber);
        if (thumbNumber < 10) {
            numberString = "0" + numberString;
        }
        thumbFileName = "Left Thumb " + numberString + ".jpg";
        switch thumbNumber {
        case 1:
            currentMood = .Euphoric;
        case 2,3:
            currentMood = .Great;
        case 4,5:
            currentMood = .Good;
        case 6,7,8:
            currentMood = .Ok;
        case 9,10,11:
            currentMood = .Bad;
        case 12,13,14:
            currentMood = .ReallyBad;
        default:
            currentMood = .Depressed
        }

        self.moodLevelLabel.text = MoodStrings[currentMood.rawValue];

        self.recordButton.hidden = false;
        self.explanationLabel.hidden = true;

        if let theImage = UIImage(named: self.thumbFileName) {
            self.leftThumbImageView.image = theImage;
        }
        else {
            assertionFailure("Couldn't create the image named " + self.thumbFileName);
        }
    }
}
