//
//  FirstViewController.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 4/28/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    // MARK: Properties

    var leftThumbImageView: UIImageView!;

    var thumbNumber: Int!, thumbFileName: String!;

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
        thumbNumber = 1;
        updateFileName();
        self.leftThumbImageView = UIImageView(frame: self.view.frame);
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Touch Handling

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)

        let possibleTouch = touches.first as? UITouch

        if let touch = possibleTouch {
            // The user has tapped outside the text field, resign first responder, if necessary.
            self.currentTouchLocation = touch.locationInView(self.view);
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event);

        self.currentTouchLocation = nil;
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event);

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

    // MARK: Helpers

    func updateFileName() {
        var numberString = String(thumbNumber);
        if (thumbNumber < 10) {
            numberString = "0" + numberString;
        }
        thumbFileName = "Left Thumb " + numberString + ".jpg";
    }
}

