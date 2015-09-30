//
//  FirstViewController.swift
//  Housie Board
//
//  Created by Pottavathini, Sathish on 2/11/15.
//  Copyright (c) 2015 Sathish Pottavathini. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
//import ZBarSDK

//import AudioToolbox

class FirstViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    
    var totCount : Int = 99
    var aData:[Bool] = Array(count: 99, repeatedValue: false)
    var prevVal: Int = -1;
    var runningCount = 0;

    @IBOutlet weak var collectionView: UICollectionView!
    
    var newLabel = UILabel(frame: CGRectMake(10, 18, 120, 100))
    var prevLabel = UILabel(frame: CGRectMake(200, 18, 120, 100))
    
    var cellWidth : CGFloat = 34;
    var cellHeight : CGFloat = 34;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData();
        newLabel.adjustsFontSizeToFitWidth = true
        prevLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(newLabel)
        self.view.addSubview(prevLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initData() {
        aData = Array(count: 99, repeatedValue: false)
        prevVal = -1;
        runningCount = 0;
    }
    
    func calcCellSize() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth : CGFloat = screenSize.width;
        let screenHeight : CGFloat = screenSize.height;
        
        cellWidth = (screenWidth * 0.9)/10;
        cellHeight = (screenWidth * 0.9)/10;
        
        collectionView.sizeThatFits(CGSizeMake(screenWidth-2, screenHeight-2))
        
    }
    
    @IBAction func updateCell(sender: AnyObject) {
        let nextNumber : Int = next()
        
        if (nextNumber == -1) {
            prevLabel.text = ""
            newLabel.text = "Game over!"
            newLabel.textColor = UIColor.redColor()
            readMe("Game over.");
            
            return;
        }

        //let _ex = NSIndexPath(forItem: (nextNumber-1), inSection: 0)
        
        //var cell = collectionView.dequeueReusableCellWithReuseIdentifier("BoardCollectionCell", forIndexPath: index) as! BoardCollectionCell

        newLabel.text = "Current Number: " + String(nextNumber)
        if (prevVal != -1) {
            prevLabel.text = "Previous Number: " + String(prevVal)
        }
        prevVal = nextNumber

        collectionView.reloadData()
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if (event!.subtype == UIEventSubtype.MotionShake) {
            updateCell(self)
        }
    }
   
    @IBAction func resetGame(sender: AnyObject) {
        
        let resetAlert = UIAlertController(title: "Restart the game?", message: "Game in progress would be reset.", preferredStyle: UIAlertControllerStyle.Alert)
        
        resetAlert.addAction(UIAlertAction(title: "Continue", style: .Destructive, handler: { (action: UIAlertAction) in
            self.resetData()
        }))
        
        resetAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
            //println("Handle Cancel Logic here")
        }))
        
        presentViewController(resetAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func `repeat`(sender: AnyObject) {
        var str : String = ""
        if (newLabel.text != nil && newLabel.text != "") {
            str += newLabel.text!
        }
        
        if (prevLabel.text != nil && prevLabel.text != "") {
            str += ", " + prevLabel.text!
        }
        
        readMe(str)
    }
    
    func resetData() {
        initData()
        
        collectionView.reloadData()
        newLabel.textColor = UIColor.blackColor()
        newLabel.text = ""
        prevLabel.text = ""
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BoardCollectionCell", forIndexPath: indexPath) as! BoardCollectionCell
        
        cell.numberLabel.text = ""
        
        let row : Int = indexPath.row
        if (row == 99) {
            cell.backgroundColor = UIColor.grayColor()
            cell.numberLabel.textColor = UIColor.whiteColor()
            cell.numberLabel.text = ":)"
            return cell
        } else {
            cell.numberLabel.textColor = UIColor.blackColor()
        }
        
        let show = aData[row]
        
        if (show) {
            cell.numberLabel.text = String(row+1)
            if ((row+1) == prevVal) {
                cell.backgroundColor = UIColor.greenColor()
                
                readMe(String(row+1))
                
            } else {
                cell.backgroundColor = UIColorFromRGB("FACC2E")
            }
        } else {
            cell.backgroundColor = UIColorFromRGB("D8D8D8")
        }
        
        //calcCellSize()
        cell.sizeThatFits(CGSizeMake(cellWidth, cellHeight))
        
        return cell
        
    }
    
    func readMe(str : String) {
        //Read it
        let synth = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: str)
        myUtterance.rate = 0.03
        synth.speakUtterance(myUtterance)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //println("a")
        return 100
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        calcCellSize()
        collectionView.reloadData()
        
    }
    
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var screenWidth : CGFloat = screenSize.width;
        var screenHeight : CGFloat = screenSize.height;
        
        var cellWidth : CGFloat = (screenWidth * 0.9)/10;
        var cellHeight : CGFloat = (screenWidth * 0.9)/10;
        
        println(cellWidth)
        print(cellHeight)
        
        
        var size : CGSize = CGSizeMake(cellWidth, cellHeight)
        return size
    }*/
    
    func next() -> Int {
        if (runningCount >= 99) {
            return -1
        }

        let num = Int(arc4random_uniform(99) + 1);
        if (num <= totCount && !aData[num-1]) {
            runningCount++
            aData[num-1] = true
            return num
        }

        return next()
    }
    
    func saveData() -> Void {
        
    }

    func updateValues() {
        //TBD    
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
    
    @IBAction func scanTicketBarcode(sender: AnyObject) {
        /*let reader : ZBarReaderController = ZBarReaderController
        reader.readerDelegate = self;
        
        //... code to get image
        
        CGImageRef imgCG = image.CGImage;
        
        
        id<NSFastEnumeration> results = [reader scanImage:imgCG];
        ZBarSymbol *symbol = nil;
        
        for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
        resultText.text = symbol.data;*/
        
    }

 }
