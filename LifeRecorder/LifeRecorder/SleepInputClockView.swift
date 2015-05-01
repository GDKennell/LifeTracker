//
//  SleepInputClockView.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 4/30/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import UIKit

class SleepInputClockView: UIView {
    var clockRadius: CGFloat?;
    let clockLineWidth: CGFloat! = 5.0;


    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        let center = self.center

        clockRadius = floor(self.frameWidth / 3.0);

        //         CGPathCreateMutable (CGContextBeginPath)
        var clockPath = CGPathCreateMutable()

        // CGPatMoveToPoint (CGContextMoveToPoint)
        let startPoint = CGPoint(x: center.x + clockRadius!, y: center.y);
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
}
