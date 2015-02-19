//
//  SerialNumViewController.swift
//  UDCSiOSAppV6
//
//  Created by WL on 14-12-03.
//  Copyright (c) 2014年 WL. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class SerialNumViewController: UIViewController {
    
    @IBOutlet weak var strSerial: UILabel!
    @IBOutlet weak var strName: UILabel!
    @IBOutlet weak var strSystemVersion: UILabel!
    @IBOutlet weak var strLocalizedModel: UILabel!
    
    var db:Database=Database();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        GetDB();
        strSerial.text = getHardWareString();
        //strSerial.text =  UIDevice.currentDevice().name;
        strName.text = UIDevice.currentDevice().systemName;
        strSystemVersion.text =  UIDevice.currentDevice().systemVersion;
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
    
    func getHardWareString () -> String
    {
        var result:String = "";
        for row in db.prepare("SELECT HardWareString FROM AppLicense where idAppLicense=1") {
            result = "\(row[0] as String!)";
        }
        return result;
    }
    
    
}