//
//  ViewController.swift
//  GetIDPS
//
//  Created by AlphaHack on 30/04/15.
//  Copyright (c) 2015 AlphaHack. All rights reserved.
//

import Cocoa

extension NSData {
    func hexString() -> String {
        // "Array" of all bytes:
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count:self.length)
        // Array of hex strings, one for each byte:
        let hexBytes = map(bytes) { String(format: "%02hhx", $0) }
        // Concatenate all hex strings:
        return "".join(hexBytes)
    }
}


extension String {
    func characterAtIndex(index: Int) -> Character? {
        var res : Character?
        if count(self) > index {
            let localIndex = advance(self.startIndex, index)
            res = self[localIndex]
        }
        return res
    }
    
    
    /// Create NSData from hexadecimal string representation
    /// This takes a hexadecimal representation and creates a NSData object. Note, if the string has any spaces, those are removed. Also if the string started with a '<' or ended with a '>', those are removed, too. This does no validation of the string to ensure it's a valid hexadecimal string
    /// Returns NSData represented by this hexadecimal string. Returns nil if string contains characters outside the 0-9 and a-f range.
    
    func dataFromHexadecimalString() -> NSData? {
        let trimmedString = self.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<> ")).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // make sure the cleaned up string consists solely of hex digits, and that we have even number of them
        var error : NSError?
        let regex = NSRegularExpression(pattern: "^[0-9a-f]*$", options: .CaseInsensitive, error: &error)
        let found = regex?.firstMatchInString(trimmedString, options: nil, range: NSMakeRange(0, count(trimmedString)))
        if found == nil || found?.range.location == NSNotFound || count(trimmedString) % 2 != 0 {
            return nil
        }
        
        // everything ok, so now let's build NSData
        let data = NSMutableData(capacity: count(trimmedString) / 2)
        
        for var index = trimmedString.startIndex; index < trimmedString.endIndex; index = index.successor().successor() {
            let byteString = trimmedString.substringWithRange(Range<String.Index>(start: index, end: index.successor().successor()))
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.appendBytes([num] as [UInt8], length: 1)
        }
        return data
    }
}

extension NSOpenPanel {
    var selectUrl : NSURL? {
        let fileOpenPanel = NSOpenPanel()
        fileOpenPanel.title = "Select bkpps3.bin file"
        fileOpenPanel.allowsMultipleSelection = false
        fileOpenPanel.canChooseDirectories = false
        fileOpenPanel.canChooseFiles = true
        fileOpenPanel.canCreateDirectories = false
        fileOpenPanel.runModal()
        fileOpenPanel.cancel(fileOpenPanel)
        if let urL = fileOpenPanel.URLs.first as? NSURL {
            return urL
        }
        return nil
    }
}

class ViewController: NSViewController {
    
    @IBOutlet weak var lblText: NSTextField!
    @IBOutlet weak var idpsDisplay: NSTextField!
    
    let filemgr = NSFileManager.defaultManager()
    var bytes : NSData!
    var openPanel = NSOpenPanel()
    
    @IBAction func btnOpen(sender: NSButton) {
        
        //Get the bkpps3.bin
        if let url = NSOpenPanel().selectUrl {
            let myFile: NSFileHandle? = NSFileHandle(forReadingFromURL: url, error: nil)
            
            //Read the bkpps3.bin and get the IDPS
            myFile!.seekToFileOffset(197584)
            bytes = myFile!.readDataOfLength(16)
            
            //Convert Hex to String
            let token = bytes.hexString()
            
            //Byte swap
            var byte1 = "\(String(token.characterAtIndex(2)!))" + "\(String(token.characterAtIndex(3)!))"
            var byte2 = "\(String(token.characterAtIndex(0)!))" + "\(String(token.characterAtIndex(1)!))"
            var byte3 = "\(String(token.characterAtIndex(6)!))" + "\(String(token.characterAtIndex(7)!))"
            var byte4 = "\(String(token.characterAtIndex(4)!))" + "\(String(token.characterAtIndex(5)!))"
            var byte5 = "\(String(token.characterAtIndex(10)!))" + "\(String(token.characterAtIndex(11)!))"
            var byte6 = "\(String(token.characterAtIndex(8)!))" + "\(String(token.characterAtIndex(9)!))"
            var byte7 = "\(String(token.characterAtIndex(14)!))" + "\(String(token.characterAtIndex(15)!))"
            var byte8 = "\(String(token.characterAtIndex(12)!))" + "\(String(token.characterAtIndex(13)!))"
            var byte9 = "\(String(token.characterAtIndex(18)!))" + "\(String(token.characterAtIndex(19)!))"
            var byte10 = "\(String(token.characterAtIndex(16)!))" + "\(String(token.characterAtIndex(17)!))"
            var byte11 = "\(String(token.characterAtIndex(22)!))" + "\(String(token.characterAtIndex(23)!))"
            var byte12 = "\(String(token.characterAtIndex(20)!))" + "\(String(token.characterAtIndex(21)!))"
            var byte13 = "\(String(token.characterAtIndex(26)!))" + "\(String(token.characterAtIndex(27)!))"
            var byte14 = "\(String(token.characterAtIndex(24)!))" + "\(String(token.characterAtIndex(25)!))"
            var byte15 = "\(String(token.characterAtIndex(30)!))" + "\(String(token.characterAtIndex(31)!))"
            var byte16 = "\(String(token.characterAtIndex(28)!))" + "\(String(token.characterAtIndex(29)!))"
            
            //Format IDPS
            var idps = byte1.uppercaseString + byte2.uppercaseString + byte3.uppercaseString + byte4.uppercaseString + byte5.uppercaseString + byte6.uppercaseString + byte7.uppercaseString + byte8.uppercaseString + byte9.uppercaseString + byte10.uppercaseString + byte11.uppercaseString + byte12.uppercaseString + byte13.uppercaseString + byte14.uppercaseString + byte15.uppercaseString + byte16.uppercaseString
            
            //Format spaced IDPS
            var idpsSpaced = byte1.uppercaseString + " " + byte2.uppercaseString + " " + byte3.uppercaseString + " " + byte4.uppercaseString + " " + byte5.uppercaseString + " " + byte6.uppercaseString + " " + byte7.uppercaseString + " " + byte8.uppercaseString + " " + byte9.uppercaseString + " " + byte10.uppercaseString + " " + byte11.uppercaseString + " " + byte12.uppercaseString + " " + byte13.uppercaseString + " " + byte14.uppercaseString + " " + byte15.uppercaseString + " " + byte16.uppercaseString
            
            
            //Saving idps as .TXT
            var cleaningSavingFolder = url.absoluteString?.stringByReplacingOccurrencesOfString("bkpps3.bin", withString: "", options: nil, range: nil)
            var newUrl = NSURL(string:cleaningSavingFolder!)
            
            let fileDestinationUrl = newUrl!.URLByAppendingPathComponent("idps.txt")
            let text = idps
            text.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            
            //Display the IDPS
            lblText.stringValue = "Your IDPS is:"
            idpsDisplay.stringValue = idpsSpaced
            
            //Saving idps as .BIN
            let idpsBin = newUrl!.URLByAppendingPathComponent("idps.bin")
            var finalData = idps.dataFromHexadecimalString()
            finalData!.writeToURL(idpsBin, atomically: true)
            
        } else {
            resignFirstResponder()
            lblText.stringValue = "No backup file was selected"
            idpsDisplay.stringValue = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblText.stringValue = ""
    }
}

