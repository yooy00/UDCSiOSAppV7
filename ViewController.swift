//
//  ViewController.swift
//  UDCSiOSAppV7
//
//  Created by WL on 14-12-03.
//  Copyright (c) 2014年 WL. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class ViewController: UIViewController {

    @IBOutlet weak var lbTimeNow: UILabel!
    @IBOutlet weak var lbOTPToken: UILabel!
    @IBOutlet weak var barProgress: UIProgressView!
    @IBOutlet weak var lbCountDown: UILabel!
    
    var db:Database=Database();
    var LicenseStr:String = "";
    var HWStr:String = "";
    
    var timer: NSTimer?;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //  [self initDBAddress];
        self.initDBAddress();
        LicenseStr = getLicense();
        HWStr = getHardWareString();
        
        var  TimeNow:NSDate = NSDate();
        var formatString1 = "HH:mm:ss";
        var dateFormatter: NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = formatString1;
        lbTimeNow.text = dateFormatter.stringFromDate(TimeNow);
        
        var formatString2 = "ss";
        dateFormatter.dateFormat=formatString2;
        var secondsnow:Int = dateFormatter.stringFromDate(TimeNow).toInt()!;
        lbCountDown.text = String(60 - secondsnow) + "秒";
        barProgress.progress = Float((60.0 - Double(secondsnow))/60.0);
        lbOTPToken.text = "---";
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MainClose(segue : UIStoryboardSegue)
    {
        var vc = segue.sourceViewController as SettingsViewController;
        // var ssss = vc.strYear;
    }
    
    func updateTimer(timer: NSTimer)
    {
        var  TimeNow:NSDate = NSDate();
        //var formatString1 = "yyyy年MM月dd日 HH:mm:ss";
        var formatString1 = "HH:mm:ss";
        var dateFormatter: NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = formatString1;
        lbTimeNow.text = dateFormatter.stringFromDate(TimeNow);
        
        var formatString2 = "ss";
        dateFormatter.dateFormat=formatString2;
        var secondsnow:Int = dateFormatter.stringFromDate(TimeNow).toInt()!;
        lbCountDown.text = String(60 - secondsnow) + "秒";
        barProgress.progress = Float((60.0 - Double(secondsnow))/60.0);
        
        GetTokenString ();
        
    }
    
    func initDBAddress() -> Void
    {
        var paths:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentsDirectory:NSString = paths.objectAtIndex(0) as NSString;
        var path:NSString = documentsDirectory.stringByAppendingPathComponent("udcsiosappdb.sqlite3");
        var fileManager:NSFileManager = NSFileManager.defaultManager();
        var find:Bool = fileManager.fileExistsAtPath(path);
        
//        if find
//        {
//            var aaa:NSErrorPointer = nil;
//            fileManager.removeItemAtPath(path, error: aaa);
//            find = fileManager.fileExistsAtPath(path);
//        }
        
        if find
        {
            NSLog("Database file have already existed.");
            db = Database(path);
        }
        else
        {
            db = Database(path);
            db.execute("CREATE TABLE IF NOT EXISTS AppLicense (idAppLicense INT PRIMARY KEY, LicenseString VARCHAR(45),HardWareString VARCHAR(45),ifUseNine INT,NineNum VARCHAR(45))");
            let jr = db.prepare("INSERT INTO AppLicense (idAppLicense, LicenseString, HardWareString,ifUseNine,NineNum) VALUES (?,?,?,?,?)");
            
            HWStr = "";
            for (var i=0; i<6; i++)
            {
                var value:Int = Int(arc4random() % 10);
                HWStr = HWStr + "\(value)";
            }
            
            jr.run(1,"8M4VKT6N5171866D8F7885687B6862",HWStr,0,"");
        }
        
    }
    
    
    func getLicense () -> String
    {
        var result:String = "";
        for row in db.prepare("SELECT LicenseString FROM AppLicense where idAppLicense=1") {
            result = "\(row[0] as String!)";
        }
        return result;
    }
    
    func getHardWareString () -> String
    {
        var result:String = "";
        for row in db.prepare("SELECT HardWareString FROM AppLicense where idAppLicense=1") {
            result = "\(row[0] as String!)";
        }
        return result;
    }
    
    func GetTokenString () -> Void
    {
        //var result:String = "";
        var NewToken = ComputeToken();
        NewToken.IMEI = HWStr;
        NewToken.LicenseString = LicenseStr;
        
        if (LicenseStr == "") {
            lbOTPToken.text="请注册";
        }
        else
        {
            var Checkresult:NSString = NewToken.CheckLicense(LicenseStr);
            
            if (Checkresult != "授权无效！")
            {
                var NR:NSRange = Checkresult.rangeOfString("已");
                var intNR:Int = NR.length;
                if (intNR<=0 ) {
                    //可以计算了
                    var formatString = "yyyy-MM-dd HH:mm";
                    var dateFormat: NSDateFormatter = NSDateFormatter();
                    dateFormat.dateFormat = formatString;
                    var currentDateStr:String = dateFormat.stringFromDate(NSDate());
                    NewToken.ConditionDateTime = currentDateStr;
                    var TokenString:String = NewToken.GetToken();
                    lbOTPToken.text=TokenString;
                }
                else
                {
                    lbOTPToken.text="授权已过期";
                }
            }
        }
      // return result;
    }
    
    
    
    
    



}

