//
//  TimeAdjustmentViewController.swift
//  UDCSiOSAppV6
//
//  Created by WL on 14-12-03.
//  Copyright (c) 2014年 WL. All rights reserved.
//

import Foundation
import UIKit

class TimeAdjustmentViewController: UIViewController {
    
    @IBOutlet weak var DateTimePicker: UIPickerView!
    @IBOutlet weak var lbNetTime: UILabel!
    @IBOutlet weak var lbInterval: UILabel!

    
    var Days:[String] = [];
    var Hours:[String] = [];
    var Minutes:[String] = [];
    var Seconds:[String] = [];
    
    var timer: NSTimer?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initArrays();
        // Do any additional setup after loading the view, typically from a nib
        DateTimePicker.dataSource=self;
        DateTimePicker.delegate=self;
        DateTimePicker.showsSelectionIndicator = true;
        //var iiii:Float = DateTimePicker.
        var ssss:CGSize =  DateTimePicker.rowSizeForComponent(0)
        NSLog("\(ssss.width)    \(ssss.height)");
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true);
        
    }
    // /Users/WL/Projects/UDCSiOSAppV7/UDCSiOSAppV7/TimeAdjustmentViewController.swift:27:43: Use of unresolved identifier 'UIViewAutoresizingFlexibleWidth'
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initArrays()->Void
    {
        var i : Int = 0;
        for i = 0; i<=23 ; i++
        {
            Hours.append(String(i));
        }
        
        for i = 0; i<=59 ; i++
        {
            Minutes.append(String(i));
            Seconds.append(String(i));
        }
        var TimeNow:NSDate = NSDate();
        for i = 0; i<=60 ; i++
        {
            var TimeSpan:NSTimeInterval=NSTimeInterval((24*60*60)*(i - 30));
            var datetime:NSDate = TimeNow.dateByAddingTimeInterval(TimeSpan);
            var formatString1 = "yyyy年MM月dd日";
            var dateFormatter: NSDateFormatter = NSDateFormatter();
            dateFormatter.dateFormat = formatString1;
            Days.append(dateFormatter.stringFromDate(datetime));
        }
    }
    
    func updateTimer(timer: NSTimer)
    {
        //更新本地时间
        var  TimeNow:NSDate = NSDate();
        //var formatString1 = "yyyy年MM月dd日 HH:mm:ss";
        var formatString1 = "HH";
        var formatString2 = "mm";
        var formatString3 = "ss";
        
        var dateFormatter: NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = formatString1;
        var strhour = dateFormatter.stringFromDate(TimeNow);
        dateFormatter.dateFormat = formatString2;
        var strminute = dateFormatter.stringFromDate(TimeNow);
        dateFormatter.dateFormat = formatString3;
        var strsecond = dateFormatter.stringFromDate(TimeNow);
        
        DateTimePicker.selectRow(30, inComponent: 0, animated: true)
        DateTimePicker.selectRow(strhour.toInt()!, inComponent: 1, animated: true)
        DateTimePicker.selectRow(strminute.toInt()!, inComponent: 2, animated: true)
        DateTimePicker.selectRow(strsecond.toInt()!, inComponent: 3, animated: true)
        //更新网络时间
        var NetTime:NSDate = NSDate.networkDate();
        var formatStringNet = "yyyy年MM月dd日 HH:mm:ss";
        var dateFormatterNet: NSDateFormatter = NSDateFormatter();
        dateFormatterNet.dateFormat = formatStringNet;
        lbNetTime.text = dateFormatterNet.stringFromDate(NetTime)
        //lbInterval.text =  NetTime.timeIntervalSinceDate(NSDate()).description;
        
        //var i:Double = Double( lbInterval.text)!;
        // NSString..
        var numberFormatter:NSNumberFormatter = NSNumberFormatter();
        var tempnum:Float = 0;
        var tempstr:String = NetTime.timeIntervalSinceDate(NSDate()).description;
        tempnum = Float( numberFormatter.numberFromString(tempstr)!);
        tempnum = tempnum * 100000;
        var tempintnum:Int = Int(tempnum);
        tempnum = Float(tempintnum) / 100000.0;

        lbInterval.text = "\(tempnum)s";

        
        
        
    }
    
    
    
    

}