//
//  SettingsViewController.swift
//  UDCSiOSAppV7
//
//  Created by WL on 14-12-04.
//  Copyright (c) 2014年 WL. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switchUseNine: UISwitch!
    
    var db:Database=Database();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GetDB();
        if getifUseNine()
        {
            switchUseNine.on = true;
        }
        else
        {
            switchUseNine.on = false;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func GetDB()->Void
    {
        var paths:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        var documentsDirectory:NSString = paths.objectAtIndex(0) as NSString;
        var path:NSString = documentsDirectory.stringByAppendingPathComponent("udcsiosappdb.sqlite3");
        var fileManager:NSFileManager = NSFileManager.defaultManager();
        var find:Bool = fileManager.fileExistsAtPath(path);
        
        if find
        {
            // NSLog("Database file have already existed.");
            db = Database(path);
        }
    }
    
    func getifUseNine () -> Bool
    {
        var result:Bool = false;
        for row in db.prepare("SELECT ifUseNine FROM AppLicense where idAppLicense=1")
        {
            var ifuse:Int = row[0] as Int!;
            result = (ifuse == 1) ? true : false;
        }
        return result;
    }
    
    var LockViewFunc:String = "";
    @IBAction func SwitchBtnClicked(sender: AnyObject) {
        if switchUseNine.on
        {
            LockViewFunc = "EnableLock";
        }
        else
        {
            LockViewFunc = "DisableLock";
        }
        performSegueWithIdentifier("GotoLockView", sender: sender);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "GotoLockView"
        {
            var vc = segue.destinationViewController as LockSettingViewController;
            vc.CurrentFunc = LockViewFunc;
        }
    }
    
    @IBAction func SettingsClose(segue : UIStoryboardSegue)
    {
        var segueViewTitle:String = segue.sourceViewController.title!!;
        if segueViewTitle == "LockView"
        {
            if getifUseNine()
            {
                switchUseNine.on = true;
            }
            else
            {
                switchUseNine.on = false;
            }
        }
    }
    
}