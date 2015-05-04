//
//  SleepInputViewController.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 4/29/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import UIKit

class SleepInputViewController : UIViewController {
    // MARK: Properties
    var clockView: SleepInputClockView?;

    // MARK: Lifetime

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        clockView = SleepInputClockView();
        self.view.addSubview(clockView!);
        clockView!.frame = CGRectMake(0, 0, self.view.frameWidth, self.view.frameHeight);
        clockView!.backgroundColor = UIColor.whiteColor();
    }

    override func viewWillAppear(animated: Bool) {

    }

    // MARK: Touch Handling
//    enum TouchFunction {
//        case Began, Moved, Ended
//    }
//
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        super.touchesBegan(touches, withEvent: event)
//        self.propogateTouchEvent(self.view, functionType: TouchFunction.Began, touches: touches, event: event)
//
//        let possibleTouch = touches.first as? UITouch
//
//        if let touch = possibleTouch {
//
//        }
//    }
//
//
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        super.touchesEnded(touches, withEvent: event);
//        self.propogateTouchEvent(self.view, functionType: TouchFunction.Ended, touches: touches, event: event)
//
//    }
//
//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        super.touchesMoved(touches, withEvent: event);
//        self.propogateTouchEvent(self.view, functionType: TouchFunction.Moved, touches: touches, event: event)
//        let possibleTouch = touches.first as? UITouch;
//        if let touch = possibleTouch {
//
//        }
//    }

    // MARK: Helpers
//    func propogateTouchEvent(view: UIView!, functionType: TouchFunction, touches: Set<NSObject>, event: UIEvent) {
//        return;
//        for possibleSubview in view.subviews {
//            let subview = possibleSubview as? UIView
//            if (subview == nil) {
//                continue
//            }
//            switch functionType {
//            case .Began:
//                subview?.touchesBegan(touches, withEvent: event)
//            case .Ended:
//                subview?.touchesEnded(touches, withEvent: event)
//            default:
//                subview?.touchesMoved(touches, withEvent: event);
//            }
//            propogateTouchEvent(subview!, functionType: functionType, touches: touches, event: event);
//        }
//    }

}











































