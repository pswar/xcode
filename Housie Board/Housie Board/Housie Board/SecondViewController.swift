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
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell_\(indexPath.row)");
        let tot = getDouble(textAmount.text!);
        
        var perc:Double;
        
        var txt = "";
        if (tot > 0) {
            switch (indexPath.row) {
            case 0:
                perc = getDouble(textQ5.text);
                txt += "①  Quick5:  \(toMoney(perc * tot * 0.01))"
                break;
            case 1:
                perc = getDouble(textR1.text);
                txt += "②  Row 1:  \(toMoney(perc * tot * 0.01))"
                break;
            case 2:
                perc = getDouble(textR2.text);
                txt += "③  Row 2:  \(toMoney(perc * tot * 0.01))"
                break;
            case 3:
                perc = getDouble(textR3.text);
                txt += "④  Row 3:  \(toMoney(perc * tot * 0.01))"
                break;
            case 4:
                perc = getDouble(textFull.text);
                txt += "⑤  Full House:  \(toMoney(perc * tot * 0.01))"
                break;
            default:
                txt = "-"
                break;
            }
        }
        
        cell.textLabel?.text = txt;
        cell.backgroundColor = (indexPath.row%2==0) ? UIColorFromRGB("FACC2E"): UIColorFromRGB("D8D8D8");
        return cell;
    }
    
    @IBAction func calcAmount(sender: AnyObject) {
        tableView.reloadData();
    }
    
    //====Utilities====
    
    func toMoney(val:Double) -> String {
        return String(format: "$ %.2f", val)
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
    
    
    //**** Search functionality ****
    //@IBOutlet weak var txtSearch: UITextField!
    //@IBOutlet weak var tableResults: UITableView!
    var tableData: NSArray = [];
    
    /*@IBAction func searchFor(sender: AnyObject) {
        searchItunesFor(txtSearch.text!);
        tableResults.reloadData();
    }*/
    
    /*class MyClass1 : UITableViewDataSource {
        @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5;
        }
        
        @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell_\(indexPath.row)");
            
            return cell
        }
        
    }*/
    
    func searchItunesFor(searchTerm: String) {
        //tableResults.dataSource = iTunesData();
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        //if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                self.println("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    self.println(error!.localizedDescription)
                }
                
                do {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        
                        if let results: NSArray = jsonResult["results"] as? NSArray {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableData = results
                                //self.tableResults!.reloadData()
                                
                                self.println(results[0].description);
                            })
                        }
                    }
                    
                } catch let error as NSError? {
                    self.println("ERROR JSON: \(error?.description)")
                }
            })
            
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }
    
    func println(str: String) -> Void {
        NSLog("@[\(NSDate())] \(str)");
    }
    
}

