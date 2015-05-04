//
//  UIView+Shortcuts.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 4/28/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var frameX: CGFloat {
        get {
            return self.frame.origin.x;
        }
        set (newX) {
            self.frame = CGRectMake(newX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        }
    }
    var frameY: CGFloat {
        get {
            return self.frame.origin.y;
        }
        set (newY) {
            self.frame = CGRectMake(self.frame.origin.x, newY, self.frame.size.width, self.frame.size.height);
        }
    }
    var frameHeight: CGFloat {
        get {
            return self.frame.size.height;
        }
        set (newHeight) {
            self.frame = CGRectMake(self.frameX, self.frameY, self.frame.size.width, newHeight);
        }
    }
    var frameWidth: CGFloat {
        get {
            return self.frame.size.width;
        }
        set (newWidth) {
            self.frame = CGRectMake(self.frameX, self.frameY, newWidth, self.frameHeight);
        }
    }
    var size: CGSize {
        get {
            return self.frame.size;
        }
        set (newSize) {
            self.frame = CGRectMake(self.frameX, self.frameY, newSize.width, newSize.height);
        }
    }

    func containsPoint(point: CGPoint) -> Bool {
        return (point.x >= 0 && point.x <= self.frameWidth
            && point.y >= 0 && point.y <= self.frameHeight);
    }
}
