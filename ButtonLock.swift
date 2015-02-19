//
//  ButtonLock.swift
//  UDCSiOSAppV6
//
//  Created by WL on 14-12-01.
//  Copyright (c) 2014年 WL. All rights reserved.
//

import Foundation
import UIKit
class ButtonLock {
    var Button:UIButton!;
    
    var CenterInMainLocation:CGPoint!;
    var CenterInImgLocation:CGPoint!;
    var CenterMainLocationX:CGFloat!;
    var CenterMainLocationY:CGFloat!;
    var CenterImgLocationX:CGFloat!;
    var CenterImgLocationY:CGFloat!;
    
    var MainView: UIView!;
    var ImgView: UIImageView!
    
    var isSelected : Bool = false;
    
    init(mainView: UIView!,imgView: UIImageView!)
    {
        self.MainView = mainView;
        self.ImgView = imgView;
    }
    
    func CountValue() -> Void
    {
        CenterInMainLocation = Button.center;
        CenterInImgLocation = ImgView.convertPoint(Button.center, fromView: MainView);
        CenterMainLocationX = CenterInMainLocation.x;
        CenterMainLocationY = CenterInMainLocation.y;
        CenterImgLocationX = CenterInImgLocation.x;
        CenterImgLocationY = CenterInImgLocation.y;
    }
    
    func BeSelected() -> Void
    {
        isSelected = true;
        Button.setBackgroundImage(UIImage(named: "imgHighLight"), forState: UIControlState.Normal);
    }
    
    func DisSelected() -> Void
    {
        isSelected = false;
        Button.setBackgroundImage(UIImage(named: "imgNormal"), forState: UIControlState.Normal);
    }
    
    func ContainPoint(PointInMainLocation:CGPoint!) -> Bool
    {
        var result:Bool = false;
        
        var BtnViewRect:CGRect = Button.frame;
        
        if CGRectContainsPoint(BtnViewRect, PointInMainLocation)
        {
            if isSelected == false
            {
                result = true;
            }
        }
        return result;
    }
    
}