//
//  ViewController.swift
//  NumberedLines
//
//  Created by Michael Dautermann on 4/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

import Cocoa

extension NSUserInterfaceItemIdentifier {
    static let rowNumberItem = NSUserInterfaceItemIdentifier("RowNumberItem")
}

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var nlTextView : NLTextView!
    @IBOutlet weak var nlLineNumberView : NSTableView!
    @IBOutlet weak var nlTextScrollView : SynchroScrollView!
    @IBOutlet weak var nlLineNumberScrollView : SynchroScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let fixedFont = NSFont(name: "Courier New", size: 14.0) {
            nlTextView.font = fixedFont
        }
        
        self.nlTextScrollView.setSynchronizedScrollView(scrollView: self.nlLineNumberScrollView)
        self.nlLineNumberScrollView.setSynchronizedScrollView(scrollView: self.nlTextScrollView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(numberOfLinesUpdated(notification:)), name: NSNotification.Name("NumberOfLinesChanged"), object: nil)
    }

    override func viewWillAppear()
    {
        self.document?.viewController = self

        // if this is a brand new (or empty) document, we'll use the "TextViewContent" build into this app
        //
        // otherwise, let's display the document contents as read from disk

        if let documentContents = self.document?.documentContent {
            self.nlTextView.string = documentContents
        } else {
            if let initialContentFileURL = Bundle.main.url(forResource: "TextViewContent", withExtension: "txt") {
                do {
                    let initialContents = try String(contentsOf: initialContentFileURL)
                    self.nlTextView.string = initialContents
                } catch let error as NSError {
                    print("error while loading initial contents at \(initialContentFileURL.absoluteString) - \(error.localizedDescription)")
                }
            }
        }
        
        // set the initial number in the line number column
        self.nlTextView.didChangeText()
    }
    
    /// whenever the number of lines is updated in the text view, reload the line numbers
    @objc func numberOfLinesUpdated(notification : Notification) {
        self.nlLineNumberView.reloadData()
    }
    
    var document: Document? {
        return view.window?.windowController?.document as? Document
    }
    
    // MARK: NSTableView data source & delegate methods
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.nlTextView.numberOfLines
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var result = tableView.makeView(withIdentifier: .rowNumberItem, owner: self)
        
        if (result == nil) {
            if let fontFromTextView = self.nlTextView.font {
                let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 50, height: fontFromTextView.pointSize))
                textField.isBezeled = false
                textField.identifier = .rowNumberItem
                textField.font = fontFromTextView
                textField.textColor = NSColor.gray
                textField.backgroundColor = NSColor.clear
                
                result = textField
            }
        }

        if let textField = result as? NSTextField {
            textField.stringValue = "\(row)"
        }
        
        return result
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
}

