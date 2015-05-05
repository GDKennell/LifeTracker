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

//MARK: Marker View
class SleepInputMarkerView: UIView {
    // MARK: Properties
    var draggingTouch: UITouch?;
    var clockCenter: CGPoint?;
    var clockRadius: CGFloat?;
    var currentAngle: CGFloat?;

    let markerLineWidth: CGFloat! = 2.0;
    let markerRadius: CGFloat! = 10.0;

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

            self.moveToAngle(touchAngle);
            let clockView = self.superview as! SleepInputClockView
            clockView.updateViews()
        }
    }

    // MARK: Helpers

    // Default position is bottom of cirle, facing down
    // Angle is measured clockwise from straight down
    func moveToAngle(angle: CGFloat!) {
        self.frameX =  (-sin(angle) * clockRadius!) + clockCenter!.x - (self.frameWidth / 2.0);
        self.frameY = (cos(angle) * clockRadius!) + clockCenter!.y - (self.frameHeight / 2.0);
        self.currentAngle = angle;
        let clockView = self.superview as! SleepInputClockView;
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

//MARK: Sleep Arc View
class SleepInputSleepArcView: UIView {
    // MARK: Properties
    let sleepArcLineWidth: CGFloat! = 4.0;
    weak var clockView: SleepInputClockView?;

    var startAngle: CGFloat?, endAngle: CGFloat?;
    var drawingContext: CGContextRef?;

    // MARK: Initializers
    func setUpView() {
        self.backgroundColor = UIColor.clearColor()
        clockView = self.superview as? SleepInputClockView
        assert(clockView != nil, "SleepInputSleepArcView must be added to superview before calling setUpView")

        self.size = clockView!.size;
        self.frame.origin = CGPoint(x: 0,y: 0);
        self.userInteractionEnabled = true;
    }

    override func drawRect(rect: CGRect) {
//        self.drawArc();
    }

    func drawArcFromAngle(startAngle_: CGFloat!, toAngle endAngle_:CGFloat!) {
        self.startAngle = startAngle_;
        self.endAngle = endAngle_;
        self.drawArc();
    }

    // MARK: Helpers
    func drawArc() {
        if (self.drawingContext == nil) {
            self.drawingContext = UIGraphicsGetCurrentContext();
        }

        if (self.startAngle == nil || self.endAngle == nil) {
            return;
        }

        var sleepArcPath = CGPathCreateMutable();
        let sleepArcStartPoint = clockView!.markers.first.center;
        CGPathMoveToPoint(sleepArcPath, nil, sleepArcStartPoint.x, sleepArcStartPoint.y);

        CGPathAddArc(sleepArcPath, nil, clockView!.clockCenter!.x, clockView!.clockCenter!.y, clockView!.clockRadius!, self.startAngle!, self.endAngle!, true);
        let strokedPath = CGPathCreateCopyByStrokingPath(sleepArcPath, nil, sleepArcLineWidth, kCGLineCapButt, kCGLineJoinMiter, CGFloat(10.0))

        assert(drawingContext != nil, "wtf");
        CGContextAddPath(drawingContext, strokedPath);

        CGContextSetStrokeColorWithColor(drawingContext, UIColor.blueColor().CGColor)
        CGContextSetLineWidth(drawingContext, sleepArcLineWidth)

        CGContextStrokePath(drawingContext);

        NSLog("Drawing sleep arc from %lf to %lf", self.startAngle! * CGFloat(180.0 / M_PI),
            self.endAngle! * CGFloat(180.0 / M_PI))
    }
}

//MARK: Clock View
class SleepInputClockView: UIView {
    // MARK: Properties

    // Parameters
    var clockRadius: CGFloat?;
    let clockLineWidth: CGFloat! = 2.0;
    var clockCenter: CGPoint?;

    // Drawing
    var clockLayer: CGLayerRef?;
    var drawingContext: CGContextRef?;

    // Subviews
    var markers: (first: SleepInputMarkerView!, second: SleepInputMarkerView!) = (SleepInputMarkerView(), SleepInputMarkerView());
    var sleepArc: SleepInputSleepArcView! = SleepInputSleepArcView();

    // MARK: UIView methods
    override func drawRect(rect: CGRect) {
        NSLog("clock: drawRect");
        super.drawRect(rect)
        if (self.drawingContext == nil) {
            self.drawingContext = UIGraphicsGetCurrentContext();
        }
        clockCenter = self.center

        clockRadius = floor(self.frameWidth / 3.0);

        CGContextClearRect(drawingContext, self.frame);
        CGContextSetFillColorWithColor(drawingContext!, UIColor.whiteColor().CGColor);
        CGContextFillRect(drawingContext, self.frame);
        self.drawClock();
        self.drawMarkers();
    }

    // MARK: Helpers
    func updateViews() {

//        self.drawClock();
//        self.drawSleepArc();
    }

    func drawClock() {
        //         CGPathCreateMutable (CGContextBeginPath)
        if (clockLayer == nil) {
            clockLayer = CGLayerCreateWithContext(self.drawingContext!, self.frame.size, nil);

            var clockPath = CGPathCreateMutable()

            let startPoint = CGPoint(x: clockCenter!.x + clockRadius!, y: clockCenter!.y);
            CGPathMoveToPoint(clockPath, nil, startPoint.x, startPoint.y);

//        NSLog("drawClock: addArc(center: %@, radius: %lf", NSStringFromCGPoint(self.center), clockRadius!);
            CGPathAddArc(clockPath, nil, self.center.x, self.center.y, clockRadius!, 0.0 as CGFloat, CGFloat(2.0 * M_PI), true);
            let strokedPath = CGPathCreateCopyByStrokingPath(clockPath, nil, clockLineWidth, kCGLineCapButt, kCGLineJoinMiter, CGFloat(10.0));

            let clockLayerContext = CGLayerGetContext(clockLayer);

            CGContextAddPath(clockLayerContext, strokedPath);

            CGContextSetStrokeColorWithColor(clockLayerContext, UIColor.blackColor().CGColor)
            CGContextSetLineWidth(clockLayerContext, clockLineWidth)

            CGContextStrokePath(clockLayerContext);
        }

        // CGContextStrokePath
        assert(drawingContext != nil, "wtf");
        CGContextDrawLayerInRect(drawingContext, self.frame, clockLayer!)
    }

    func drawMarkers() {
        self.markers.first.backgroundColor = UIColor.clearColor();
        self.markers.second.backgroundColor = UIColor.clearColor();

        self.addSubview(self.markers.first);
        self.addSubview(self.markers.second);

        self.markers.first.setUpView();
        self.markers.second.setUpView();

        self.markers.first.moveToAngle(CGFloat(4.50));
        self.markers.second.moveToAngle(CGFloat(2.50));
    }

    func drawSleepArc() {
        self.addSubview(self.sleepArc);
        sleepArc.setUpView();
        sleepArc.drawArcFromAngle(self.markers.first.currentAngle! + CGFloat(M_PI_2),
                        toAngle: self.markers.second.currentAngle! + CGFloat(M_PI_2));
    }

}


