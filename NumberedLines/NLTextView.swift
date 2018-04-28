//
//  NLTextView.swift
//  NumberedLines
//
//  Created by Michael Dautermann on 4/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

import Cocoa

/// NLTextView is a NSTextView subclass of NSTextView primarily to keep track of the number of lines
class NLTextView: NSTextView {

    var numberOfLines = 1 {
        // if the number of lines changes, post a notification
        //
        // we could also define a protocol and call a delegate method here,
        // but I decided to do it this way in case we ever want multiple observers (e.g. the number of lines table view,
        // a summary view in a different window, etc.)
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("NumberOfLinesChanged"), object: self)
        }
    }
    
   func updateNumberOfLines() {
        if let layoutManager = self.layoutManager {
            let numberOfGlyphs = layoutManager.numberOfGlyphs
            
            var lineRange = NSMakeRange(0,0)
            var lineNumber = 0
            var index = 0
            // the longer the document, the longer this is likely to take
            while (index < numberOfGlyphs) {
                layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
                index = NSMaxRange(lineRange)
                lineNumber+=1
            }
            
            // design choice:  I print the next line number after the last line
            self.numberOfLines = lineNumber+1
        }
    }
    
    /// resizing the window means wrapping can change and so can line numbers
    @objc func viewContentBoundsDidChange(notification : Notification) {
        self.updateNumberOfLines()
    }
    
    /// anytime the text changes, let's calculate the number of lines
    override func didChangeText() {
        self.updateNumberOfLines()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.postsFrameChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(viewContentBoundsDidChange(notification:)), name: NSView.frameDidChangeNotification, object: self)
    }
    
}
