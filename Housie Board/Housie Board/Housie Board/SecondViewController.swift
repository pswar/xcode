//
//  SecondViewController.swift
//  Housie Board
//
//  Created by Pottavathini, Sathish on 2/11/15.
//  Copyright (c) 2015 Sathish Pottavathini. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var textQ5: UITextField!
    @IBOutlet weak var textR1: UITextField!
    @IBOutlet weak var textR2: UITextField!
    @IBOutlet weak var textR3: UITextField!
    @IBOutlet weak var textFull: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //createButtons()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "My test cell");
        let tot = getDouble(textAmount.text!);
        
        var perc:Double;
        
        var txt = "";
        if (tot > 0) {
            switch (indexPath.row) {
            case 0:
                perc = getDouble(textQ5.text);
                txt = "Quick5:  \(toMoney(perc * tot * 0.01))"
                break;
            case 1:
                perc = getDouble(textR1.text);
                txt = "Row 1:  \(toMoney(perc * tot * 0.01))"
                break;
            case 2:
                perc = getDouble(textR2.text);
                txt = "Row 2:  \(toMoney(perc * tot * 0.01))"
                break;
            case 3:
                perc = getDouble(textR3.text);
                txt = "Row 3:  \(toMoney(perc * tot * 0.01))"
                break;
            case 4:
                perc = getDouble(textFull.text);
                txt = "Full House:  \(toMoney(perc * tot * 0.01))"
                break;
            default:
                txt = "-"
                break;
            }
        }
        
        cell.textLabel?.text = txt;
        return cell;
    }
    
    func toMoney(val:Double) -> String {
        return String(format: "$ %.2f", val)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func calcAmount(sender: AnyObject) {
        
        tableView.reloadData();
    }
    
    func getDouble(text:String!) -> Double {
        if (text == "") {
            return 0.0;
        }
        
        let val : Double = (NSNumberFormatter().numberFromString(text!)?.doubleValue)!;
        
        return val;
    }
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        let scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}

