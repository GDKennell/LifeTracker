//
//  MoodInputViewController.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 4/28/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import UIKit

let NumMoodStates = 7;

enum MoodState: String {
    case Euphoric = "Euphoric"
    case Great = "Great"
    case Good = "Good"
    case Ok = "Ok"
    case Bad = "Bad"
    case ReallyBad = "ReallyBad"
    case Depressed = "Depressed"
}

let numEnergyStates = 5;

enum EnergyState: String {
    case Manic = "Manic"
    case High = "High"
    case Average = "Average"
    case Low = "Low"
    case Lethargic = "Lethargic"
}

class MoodInputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: Properties

    @IBOutlet var leftThumbImageView: UIImageView!;
    @IBOutlet var moodLevelLabel: UILabel!;

    @IBOutlet var explanationLabel: UILabel!;
    @IBOutlet var recordButton: UIButton!;

    @IBOutlet var energyLevelPicker: UIPickerView!;

    var thumbNumber: Int!, thumbFileName: String!;
    var currentMoodState: MoodState!
    var currentEnergyState: EnergyState!

    var currentTouchLocation: CGPoint?;

    let movementThreshold = 8;
    let minThumbNumber = 1;
    let maxThumbNumber = 15;
    // MARK: Lifetime

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        thumbNumber = 7;
        updateFileName();

        if let theImage = UIImage(named: self.thumbFileName) {
            self.leftThumbImageView.image = theImage;
        }
        else {
            println("Couldn't create the image named " + self.thumbFileName);
            exit(1);
        }
        self.view.addSubview(leftThumbImageView);
        leftThumbImageView.frame = self.view.frame;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        self.recordButton.hidden = true;
        self.explanationLabel.hidden = false;
        self.currentEnergyState = EnergyState.Average;
        self.energyLevelPicker.selectRow(2, inComponent: 0, animated: false);
        self.currentEnergyState = EnergyState.Average;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.leftThumbImageView.image = UIImage(named: self.thumbFileName);
            }
        }
    }


    // MARK: UIPickerViewDelegate, UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numEnergyStates;
    }

    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var returnString: String?;
        switch row {
        case 0:
            returnString = EnergyState.Manic.rawValue;
        case 1:
            returnString = EnergyState.High.rawValue;
        case 2:
            returnString = EnergyState.Average.rawValue;
        case 3:
            returnString = EnergyState.Low.rawValue;
        default:
            returnString = EnergyState.Lethargic.rawValue;
        }
        return NSAttributedString(string: returnString!);
    }

    // MARK: Helpers

    func updateFileName() {
        var numberString = String(thumbNumber);
        if (thumbNumber < 10) {
            numberString = "0" + numberString;
        }
        thumbFileName = "Left Thumb " + numberString + ".jpg";
        switch thumbNumber {
        case 1,2:
            currentMoodState = MoodState.Euphoric;
        case 3,4:
            currentMoodState = MoodState.Great;
        case 5,6:
            currentMoodState = MoodState.Good;
        case 7,8:
            currentMoodState = MoodState.Ok;
        case 9,10:
            currentMoodState = MoodState.Bad;
        case 11,12:
            currentMoodState = MoodState.ReallyBad;
        default:
            currentMoodState = MoodState.Depressed
        }

        self.moodLevelLabel.text = currentMoodState.rawValue;

        self.recordButton.hidden = false;
        self.explanationLabel.hidden = true;
    }
}
