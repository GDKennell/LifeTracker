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

}











































