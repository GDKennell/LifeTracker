//
//  SleepInputClockView.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 4/30/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import UIKit

func distance(start: CGPoint!, end: CGPoint!) -> CGFloat! {
    return sqrt(pow((start.x - end.x),2.0) + pow((start.y - end.y),2))
}

class SleepInputMarkerView: UIView {
    // MARK: Properties
    var draggingTouch: UITouch?;
    var clockCenter: CGPoint?;
    var clockRadius: CGFloat?;
    var currentAngle: CGFloat?;

    let markerLineWidth: CGFloat! = 2.0;
    let markerRadius: CGFloat! = 20.0;

    // MARK: Initializers

    // Should be called after frame is set and view is added to superview
    func setUpView() {
        let clockView = self.superview as! SleepInputClockView
        clockCenter = clockView.clockCenter
        clockRadius = clockView.clockRadius
        self.size = CGSizeMake(100, 100);
        self.frameX = 150;
        self.frameY = 150;
        currentAngle = 0.0;
        self.userInteractionEnabled = true
    }

    override func drawRect(rect: CGRect) {
        self.drawMarker();
    }

    // MARK: Touch Handling
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let possibleTouch = touches.first as? UITouch
        let touchLocation = possibleTouch?.locationInView(self)
        let touch = possibleTouch
        if touch != nil && self.containsPoint(touchLocation!) {
            draggingTouch = touch;
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let possibleTouch = touches.first as? UITouch
        let touchLocation = possibleTouch?.locationInView(self.superview)
        if (possibleTouch != nil) && possibleTouch == draggingTouch {
            var hypotenuse = distance(clockCenter!, touchLocation!)
            let vertical = clockCenter!.y - touchLocation!.y;

            var touchAngle: CGFloat! = asin(vertical / hypotenuse) + CGFloat(M_PI / 2.0)
            if (touchLocation!.x > clockCenter!.x) {
                let angleDifference: CGFloat! = CGFloat(M_PI) - touchAngle;
                touchAngle = touchAngle + (2.0 * angleDifference);
            }

            NSLog("vertical (%lf) / hypotenuse (%lf) = %lf", vertical, hypotenuse, vertical / hypotenuse);
            self.moveToAngle(touchAngle);
        }
    }

    // MARK: Helpers

    // Default position is bottom of cirle, facing down
    // Angle is measured clockwise from straight down
    func moveToAngle(angle: CGFloat!) {
//        self.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
//        var matrix = CGAffineTransformMakeTranslation(self.center.x, self.center.y)
//        matrix = CGAffineTransformRotate(matrix, angle);
//        self.transform = matrix;
        self.frameX =  (-sin(angle) * clockRadius!) + clockCenter!.x - (self.frameWidth / 2.0);
        self.frameY = (cos(angle) * clockRadius!) + clockCenter!.y - (self.frameHeight / 2.0);
        //        self.transform = CGAffineTransformRotate(self.transform, angle!);
        NSLog("moveToAngle: %lf degrees", angle * CGFloat(180.0) / CGFloat(M_PI));
    }

    func drawMarker() {
        //         CGPathCreateMutable (CGContextBeginPath)
        var markerPath = CGPathCreateMutable()
        var markerCenter = CGPointMake(self.frameWidth / 2.0, self.frameHeight / 2.0)
        // CGPatMoveToPoint (CGContextMoveToPoint)
        let startPoint = CGPoint(x: markerCenter.x + markerRadius, y: markerCenter.y);
        CGPathMoveToPoint(markerPath, nil, startPoint.x, startPoint.y);

        // CGPathAddArc (CGContextAddArc)
        CGPathAddArc(markerPath!, nil, markerCenter.x, markerCenter.y, markerRadius!, 0.0 as CGFloat, CGFloat(2.0 * M_PI), true);
        let strokedPath = CGPathCreateCopyByStrokingPath(markerPath, nil, markerLineWidth, kCGLineCapButt, kCGLineJoinMiter, CGFloat(10.0));

        // CGContextStrokePath

        var drawingContext = UIGraphicsGetCurrentContext()
        assert(drawingContext != nil, "wtf");
        CGContextAddPath(drawingContext, strokedPath);

        CGContextSetStrokeColorWithColor(drawingContext, UIColor.greenColor().CGColor)
        CGContextSetLineWidth(drawingContext, markerLineWidth)

        CGContextStrokePath(drawingContext);
    }
}

class SleepInputClockView: UIView {
    // MARK: Properties

    var clockRadius: CGFloat?;
    let clockLineWidth: CGFloat! = 2.0;
    var clockCenter: CGPoint?;

    // MARK: UIView methods
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        self.drawClock();
        self.drawMarkers();
    }

    // MARK: Helpers
    func drawClock() {
        clockCenter = self.center

        clockRadius = floor(self.frameWidth / 3.0);
        //         CGPathCreateMutable (CGContextBeginPath)
        var clockPath = CGPathCreateMutable()

        // CGPatMoveToPoint (CGContextMoveToPoint)
        let startPoint = CGPoint(x: clockCenter!.x + clockRadius!, y: clockCenter!.y);
        CGPathMoveToPoint(clockPath, nil, startPoint.x, startPoint.y);

        // CGPathAddArc (CGContextAddArc)
        CGPathAddArc(clockPath!, nil, center.x, center.y, clockRadius!, 0.0 as CGFloat, CGFloat(2.0 * M_PI), true);
        let strokedPath = CGPathCreateCopyByStrokingPath(clockPath, nil, clockLineWidth, kCGLineCapButt, kCGLineJoinMiter, CGFloat(10.0));

        // CGContextStrokePath

        var drawingContext = UIGraphicsGetCurrentContext()
        assert(drawingContext != nil, "wtf");
        CGContextAddPath(drawingContext, strokedPath);

        CGContextSetStrokeColorWithColor(drawingContext, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(drawingContext, clockLineWidth)
        
        CGContextStrokePath(drawingContext);
    }

    func drawMarkers() {
        let testMarker = SleepInputMarkerView();
        testMarker.backgroundColor = UIColor.clearColor();
        self.addSubview(testMarker)
        testMarker.setUpView()
        testMarker.moveToAngle(CGFloat(4.0*M_PI/3.0));
    }
}


