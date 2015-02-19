//
//  TimeAdjustmentViewControllerExtension.swift
//  UDCSiOSAppV7
//
//  Created by WL on 14-12-04.
//  Copyright (c) 2014年 WL. All rights reserved.
//

import Foundation
import UIKit






extension TimeAdjustmentViewController:UIPickerViewDataSource
{
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 4;
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 0
        {
            if (component == 0)
            {
                return 61;
            }
            else if (component == 1)
            {
                return 24;
            }
            else if (component == 2)
            {
                return 60;
            }
            else if (component == 3)
            {
                return 60;
            }
            else
            {
                return -1;
            }
        }
        else
        {
            return -1;
        }
    }
    
}

extension TimeAdjustmentViewController:UIPickerViewDelegate
{
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        if pickerView.tag == 0
        {
            if (component == 0)
            {
                return Days[row];
            }
            else if (component == 1)
            {
                return Hours[row];
            }
            else if (component == 2)
            {
                return Minutes[row];
            }
            else if (component == 3)
            {
                return Seconds[row];
            }
            else
            {
                return "";
            }
        }
        else
        {
            return "";
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        var cgf1:CGFloat = 200;
        var cgf2:CGFloat =  35;
        if pickerView.tag == 0
        {
            if (component == 0)
            {
                return cgf1;
            }
            else if (component == 1)
            {
                return cgf2;
            }
            else if (component == 2)
            {
                return cgf2;
            }
            else if (component == 3)
            {
                return cgf2;
            }
            else
            {
                return cgf2;
            }
        }
        else
        {
            return cgf2;
        }
        
    }
    
    
}

