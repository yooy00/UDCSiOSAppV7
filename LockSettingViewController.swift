//
//  LockSettingViewController.swift
//  UDCSiOSAppV6
//
//  Created by WL on 14-12-01.
//  Copyright (c) 2014年 WL. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class LockSettingViewController: UIViewController {
    
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var lbPassword: UILabel!
    
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    
    @IBOutlet weak var lbViewTitle: UILabel!
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    
    
    
    var Pressed:Bool=false;
    var ButtonArray:[ButtonLock]=[];
    var ButtonPathArray:[Int]=[];
    var CurrentFunc:String = "UnLock";
    var db:Database=Database();
    var FirstPWStr:String = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDB();

        
        
        ButtonArray = [];
        ButtonPathArray = [];
        Pressed = false;
        btn0.tag = 0;
        btn1.tag = 1;
        btn2.tag = 2;
        btn3.tag = 3;
        btn4.tag = 4;
        btn5.tag = 5;
        btn6.tag = 6;
        btn7.tag = 7;
        btn8.tag = 8;
        
        var tmpButtonLock:ButtonLock = ButtonLock(mainView: MainView,imgView: ImgView);
        tmpButtonLock.Button=btn0;
        ButtonArray.append(tmpButtonLock);
        
        tmpButtonLock = ButtonLock(mainView: MainView,imgView: ImgView);
        tmpButtonLock.Button=btn1;
        ButtonArray.append(tmpButtonLock);
        
        tmpButtonLock = ButtonLock(mainView: MainView,imgView: ImgView);
        tmpButtonLock.Button=btn2;
        ButtonArray.append(tmpButtonLock);
        
        tmpButtonLock = ButtonLock(mainView: MainView,imgView: ImgView);
        tmpButtonLock.Button=btn3;
        ButtonArray.append(tmpButtonLock);
        
        tmpButtonLock = ButtonLock(mainView: MainView,imgView: ImgView);
        tmpButtonLock.Button=btn4;
        ButtonArray.append(tmpButtonLock);
        
        tmpButtonLock = ButtonLock(mainView: MainView,imgView: ImgView);
        tmpButtonLock.Button=btn5;
        ButtonArray.append(tmpButtonLock);
        
        tmpButtonLock = ButtonLock(mainView: MainView,imgView: ImgView);
        tmpButtonLock.Button=btn6;
        ButtonArray.append(tmpButtonLock);
        
        
        tmpButtonLock = ButtonLock(mainView: MainView,imgView: ImgView);
        tmpButtonLock.Button=btn7;
        ButtonArray.append(tmpButtonLock);
        
        
        tmpButtonLock = ButtonLock(mainView: MainView,imgView: ImgView);
        tmpButtonLock.Button=btn8;
        ButtonArray.append(tmpButtonLock);
        
        for btn:ButtonLock in ButtonArray
        {
            btn.DisSelected();
            btn.CountValue();
        }
        
        
        
        if CurrentFunc == "EnableLock"
        {
            lbViewTitle.text = "设置解锁手势";
            btnComplete.hidden = false;
            btnBack.hidden = false;
        }
        else if CurrentFunc == "DisableLock"
        {
            lbViewTitle.text = "输入手势以取消";
            btnComplete.hidden = true;
            btnBack.hidden = false;
        }
        else if CurrentFunc == "UnLock"
        {
            lbViewTitle.text = "手势解锁";
            btnComplete.hidden = true;
            btnBack.hidden = true;
            

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (getifUseNine() == false) && (CurrentFunc == "UnLock")
        {
            let myStoryBoard = self.storyboard;
            let anotherView = myStoryBoard!.instantiateViewControllerWithIdentifier("MainView111") as UIViewController;
            self.presentViewController(anotherView, animated: true, completion: nil);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan (touches: NSSet, withEvent event: UIEvent)
    {
        for btn:ButtonLock in ButtonArray
        {
            btn.DisSelected();
            btn.CountValue();
        }
        ButtonPathArray = [];
        Pressed = false;
        DrawPath(CGPoint(x: 0,y: 0));
        
        var touchPoint:CGPoint = CGPoint();
        var touch:UITouch = UITouch();
        if touches.count > 0
        {
            touch = touches.anyObject() as UITouch;
        }
        
        touchPoint = touch.locationInView(MainView);
        
        var SingleButton:ButtonLock? = nil;
        for sb in ButtonArray
        {
            if sb.ContainPoint(touchPoint)
            {
                SingleButton = sb;
                break;
            }
        }
        
        if SingleButton != nil
        {
            Pressed = true;
            NSLog("Start: \(touchPoint.x), \(touchPoint.y)\n");
            SingleButton!.BeSelected();
            ButtonPathArray.append(SingleButton!.Button.tag);
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        var touchPoint:CGPoint = CGPoint();
        var touch:UITouch = UITouch();
        if touches.count > 0
        {
            touch = touches.anyObject() as UITouch;
        }
        touchPoint=touch.locationInView(MainView);
        
        if Pressed == true
        {
            var SingleButton:ButtonLock? = nil;
            for sb in ButtonArray
            {
                if sb.ContainPoint(touchPoint)
                {
                    if sb.Button.tag != ButtonArray[ButtonPathArray[ButtonPathArray.count-1]].Button.tag
                    {
                        SingleButton = sb;
                        break;
                    }
                }
            }
            
            if SingleButton != nil
            {
                ButtonPathArray.append(SingleButton!.Button.tag);
                SingleButton!.BeSelected();
                touchPoint=touch.locationInView(ImgView);
                DrawPath(touchPoint);
            }
            else
            {
                touchPoint=touch.locationInView(ImgView);
                DrawPath(touchPoint);
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        if Pressed == true
        {
            Pressed = false;
            DrawPath(CGPoint(x: 0,y: 0));
            NSLog("END\n");
            lbPassword.text = "";
            for num in ButtonPathArray
            {
                lbPassword.text = lbPassword.text! + "\(num)";
            }
            ReactTouch();
        }
        else
        {
            for btn:ButtonLock in ButtonArray
            {
                btn.DisSelected();
                btn.CountValue();
            }
            ButtonPathArray = [];
            DrawPath(CGPoint(x: 0,y: 0));
        }
    }
    
    
    func DrawPath (EndTouchPoint:CGPoint) -> Void
    {
        var ImgViewRect:CGRect = ImgView.frame;
        var ImgRect:CGRect = CGRect(x: 0, y: 0, width: ImgViewRect.width, height: ImgViewRect.height);
        
        
        UIGraphicsBeginImageContextWithOptions(ImgRect.size, false, 0);
        //获得处理的上下文
        var context:CGContextRef =  UIGraphicsGetCurrentContext();
        //指定直线样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //直线宽度
        CGContextSetLineWidth(context, 6.0);
        //设置颜色
        CGContextSetRGBStrokeColor(context, 0.314, 0.486, 0.859, 1.0);
        //开始绘制
        CGContextBeginPath(context);
        if ButtonPathArray.count <= 0
        {
            //把当前context的内容输出成一个UIImage图片
            var i :UIImage = UIGraphicsGetImageFromCurrentImageContext();
            //上下文栈pop出创建的context
            UIGraphicsEndImageContext();
            ImgView.image=i;
            return;
        }
        var StartPoint = ButtonArray[ButtonPathArray[0]].CenterInImgLocation;
        if ButtonPathArray.count > 1
        {
            for var i:Int = 1;i<ButtonPathArray.count;i++
            {
                let StartPath:Int = ButtonPathArray[i-1];
                
                let EndPath = ButtonPathArray[i];
                //画笔移动到点(31,170)
                CGContextMoveToPoint(context, ButtonArray[StartPath].CenterImgLocationX, ButtonArray[StartPath].CenterImgLocationY);
                //下一点
                CGContextAddLineToPoint(context, ButtonArray[EndPath].CenterImgLocationX, ButtonArray[EndPath].CenterImgLocationY);
                StartPoint = ButtonArray[EndPath].CenterInImgLocation;
            }
            
        }
        
        if Pressed == true
        {
            //画笔移动到点(31,170)
            CGContextMoveToPoint(context, StartPoint.x, StartPoint.y);
            //下一点
            CGContextAddLineToPoint(context, EndTouchPoint.x, EndTouchPoint.y);
            
        }
        //绘制完成
        CGContextStrokePath(context);
        //在context上绘制
        CGContextFillPath(context);
        //把当前context的内容输出成一个UIImage图片
        var i :UIImage = UIGraphicsGetImageFromCurrentImageContext();
        //上下文栈pop出创建的context
        UIGraphicsEndImageContext();
        ImgView.image=i;
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject)
    {
        for btn:ButtonLock in ButtonArray
        {
            btn.DisSelected();
            btn.CountValue();
        }
        ButtonPathArray = [];
        Pressed = false;
        DrawPath(CGPoint(x: 0,y: 0));
        lbPassword.text = "";
        FirstPWStr = "";
    }
    
    @IBAction func CompleteHand(sender: AnyObject)
    {
        if CurrentFunc == "EnableLock"
        {
            var PWStr:String = "";
            
            if ButtonPathArray.count <= 3
            {
                let tapAlert = UIAlertController(title: "手势过于简单", message: "请链接多于3个点!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
                return;
            }
            
            for num in ButtonPathArray
            {
                PWStr = PWStr + "\(num)";
            }
            
            if FirstPWStr == ""
            {
                FirstPWStr = PWStr;
                let tapAlert = UIAlertController(title: "手势通过", message: "请再次确定手势!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
                return;
            }
            else
            {
                if FirstPWStr == PWStr
                {
                    UpdateDB(1,PWStr: PWStr);
                    FirstPWStr == "";
                    let tapAlert = UIAlertController(title: "保存成功", message: "手势已成功保存!", preferredStyle: UIAlertControllerStyle.Alert)
                    tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                    self.presentViewController(tapAlert, animated: true, completion: nil)
                    ClearButtons();
                    performSegueWithIdentifier("unwindGotoLockView", sender: sender);
                    // return;
                }
                else
                {
                    FirstPWStr == "";
                    let tapAlert = UIAlertController(title: "错误", message: "两次手势不匹配，请重新输入!", preferredStyle: UIAlertControllerStyle.Alert)
                    tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                    self.presentViewController(tapAlert, animated: true, completion: nil)
                    ClearButtons();
                    //  return;
                }
            }
        }
        else if CurrentFunc == "DisableLock"
        {
            var PWStr:String = "";
            for num in ButtonPathArray
            {
                PWStr = PWStr + "\(num)";
            }
            var DBPW:String = getPWStr();
            if PWStr == DBPW
            {
                UpdateDB(0,PWStr:"");
                let tapAlert = UIAlertController(title: "手势通过", message: "手势解锁功能已关闭!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
                performSegueWithIdentifier("unwindGotoLockView", sender: sender);
                //   return;
            }
            else
            {
                let tapAlert = UIAlertController(title: "错误", message: "手势不匹配，请重新输入!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
                // return;
            }
            
            
        }
        else if CurrentFunc == "UnLock"
        {
            var PWStr:String = "";
            for num in ButtonPathArray
            {
                PWStr = PWStr + "\(num)";
            }
            var DBPW:String = getPWStr();
            if PWStr == DBPW
            {
                ClearButtons();
               	let myStoryBoard = self.storyboard;
                let anotherView = myStoryBoard?.instantiateViewControllerWithIdentifier("MainView111") as UIViewController;
                self.presentViewController(anotherView, animated: true, completion: nil);
            }
            else
            {
                let tapAlert = UIAlertController(title: "错误", message: "手势不匹配，请重新输入!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
            }
            
        }
    }
    
    func ReactTouch() -> Void
    {
        if CurrentFunc == "EnableLock"
        {
            var PWStr:String = "";
            
            if ButtonPathArray.count <= 3
            {
                let tapAlert = UIAlertController(title: "手势过于简单", message: "请链接多于3个点!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
                return;
            }
            
            for num in ButtonPathArray
            {
                PWStr = PWStr + "\(num)";
            }
            
            if FirstPWStr == ""
            {
                FirstPWStr = PWStr;
                let tapAlert = UIAlertController(title: "手势通过", message: "请再次确定手势!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
                return;
            }
            else
            {
                if FirstPWStr == PWStr
                {
                    UpdateDB(1,PWStr: PWStr);
                    FirstPWStr = "";
                    let tapAlert = UIAlertController(title: "保存成功", message: "手势已成功保存!", preferredStyle: UIAlertControllerStyle.Alert)
                    tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                    self.presentViewController(tapAlert, animated: true, completion: nil)
                    ClearButtons();
                    performSegueWithIdentifier("unwindGotoLockView", sender: nil);
                }
                else
                {
                    FirstPWStr = "";
                    let tapAlert = UIAlertController(title: "错误", message: "两次手势不匹配，请重新输入!", preferredStyle: UIAlertControllerStyle.Alert)
                    tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                    self.presentViewController(tapAlert, animated: true, completion: nil)
                    ClearButtons();
                }
            }
        }
        else if CurrentFunc == "DisableLock"
        {
            var PWStr:String = "";
            for num in ButtonPathArray
            {
                PWStr = PWStr + "\(num)";
            }
            var DBPW:String = getPWStr();
            if PWStr == DBPW
            {
                UpdateDB(0,PWStr:"");
                let tapAlert = UIAlertController(title: "手势通过", message: "手势解锁功能已关闭!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
                performSegueWithIdentifier("unwindGotoLockView", sender: nil);
                //   return;
            }
            else
            {
                let tapAlert = UIAlertController(title: "错误", message: "手势不匹配，请重新输入!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
                // return;
            }
            
            
        }
        else if CurrentFunc == "UnLock"
        {
            var PWStr:String = "";
            for num in ButtonPathArray
            {
                PWStr = PWStr + "\(num)";
            }
            var DBPW:String = getPWStr();
            if PWStr == DBPW
            {
                ClearButtons();
               	let myStoryBoard = self.storyboard;
                let anotherView = myStoryBoard?.instantiateViewControllerWithIdentifier("MainView111") as UIViewController;
                self.presentViewController(anotherView, animated: true, completion: nil);
            }
            else
            {
                let tapAlert = UIAlertController(title: "错误", message: "手势不匹配，请重新输入!", preferredStyle: UIAlertControllerStyle.Alert)
                tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                self.presentViewController(tapAlert, animated: true, completion: nil)
                ClearButtons();
            }
            
        }
    }
    
    func ClearButtons() ->Void
    {
        for btn:ButtonLock in ButtonArray
        {
            btn.DisSelected();
            btn.CountValue();
        }
        ButtonPathArray = [];
        Pressed = false;
        DrawPath(CGPoint(x: 0,y: 0));
        lbPassword.text = "";
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
        else
        {
            db = Database(path);
            db.execute("CREATE TABLE IF NOT EXISTS AppLicense (idAppLicense INT PRIMARY KEY, LicenseString VARCHAR(45),HardWareString VARCHAR(45),ifUseNine INT,NineNum VARCHAR(45))");
            let jr = db.prepare("INSERT INTO AppLicense (idAppLicense, LicenseString, HardWareString,ifUseNine,NineNum) VALUES (?,?,?,?,?)");
            
            var  HWStr = "";
            for (var i=0; i<6; i++)
            {
                var value:Int = Int(arc4random() % 10);
                HWStr = HWStr + "\(value)";
            }
            
            jr.run(1,"8M4VKT6N5171866D8F7885687B6862",HWStr,0,"");
        }
    }
    
    func getPWStr () -> String
    {
        var result:String = "";
        for row in db.prepare("SELECT NineNum FROM AppLicense where idAppLicense=1") {
            result = "\(row[0] as String!)";
        }
        return result;
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
    
    func UpdateDB(var ifuseNine:Int , var PWStr:String) -> Void
    {
        //        let jr = db.prepare("INSERT INTO AppLicense (idAppLicense, LicenseString, HardWareString,ifUseNine,NineNum) VALUES (?,?,?,?,?)");
        let jr = db.prepare(" UPDATE AppLicense SET ifUseNine = ?,NineNum = ? WHERE idAppLicense = 1");
        jr.run(ifuseNine,PWStr);
    }
    
    
}