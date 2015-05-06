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
    @IBOutlet var clockView: SleepInputClockView!;
    @IBOutlet var dateLabel: UILabel!;
    @IBOutlet var dateBackButton: UIButton!;
    @IBOutlet var dateForwardButton: UIButton!;


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
        let topSpace: CGFloat! = 150.0;
        clockView!.frame = CGRectMake(0, topSpace, self.view.frameWidth, self.view.frameHeight - topSpace);
        clockView!.backgroundColor = UIColor.whiteColor();
        clockView!.setNeedsDisplay();

        self.dateBackButton.setImage(UIImage(named: "back_button_black"), forState: UIControlState.Normal);
        self.dateBackButton.setImage(UIImage(named: "back_button_grey"), forState: UIControlState.Highlighted);
        self.dateForwardButton.setImage(UIImage(named: "forward_button_black"), forState: UIControlState.Normal);
        self.dateForwardButton.setImage(UIImage(named: "forward_button_grey"), forState: UIControlState.Highlighted);
    }

    override func viewWillAppear(animated: Bool) {

    }

}











































