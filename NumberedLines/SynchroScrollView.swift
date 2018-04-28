//
//  SynchroScrollView.swift
//  NumberedLines
//
//  Created by Michael Dautermann on 4/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

import Cocoa

/**
   ported from
 
   https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/NSScrollViewGuide/Articles/SynchroScroll.html#//apple_ref/doc/uid/TP40003537-SW5

*/
class SynchroScrollView: NSScrollView {

    weak var synchronizedScrollView : NSScrollView?
    
    func setSynchronizedScrollView(scrollView : NSScrollView) {
        // stop an existing scroll view synchronizing
        self.stopSynchronizing()
        
        self.synchronizedScrollView = scrollView
    
        let synchronizedContentView = scrollView.contentView

        // make sure the watched view is sending bounds changed
        // notifications (which it probably does anyway, but calling this
        // again won't hurt).
        synchronizedContentView.postsBoundsChangedNotifications = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(synchronizedViewContentBoundsDidChange), name: NSView.boundsDidChangeNotification, object: synchronizedContentView)
    }
    
    @objc func synchronizedViewContentBoundsDidChange(notification : Notification) {
        // get the changed content view from the notification
        if let changedContentView = notification.object as? NSClipView {
            // get the origin of the NSClipView of the scroll view that we're watching
            let changedBoundsOrigin = changedContentView.documentVisibleRect.origin
            
            // get our current origin
            let curOffset = self.contentView.bounds.origin
            var newOffset = curOffset
            
            // scrolling is synchronized in the vertical plane
            // so only modify the y component of the offset
            newOffset.y = changedBoundsOrigin.y
            
            // if our synced position is different from our current
            // position, reposition our content view
            if (NSEqualPoints(curOffset, changedBoundsOrigin) == false) {
                // note tha a scroll view waching this one will
                // get notified here
                self.contentView.scroll(newOffset)
                
                // we have to tell the NSScrollView to update its scrollers
                self.reflectScrolledClipView(self.contentView)
            }
        }
    }
    
    func stopSynchronizing()
    {
        if let actualSynchronizedScrollView = self.synchronizedScrollView {
            let synchronizedContentView = actualSynchronizedScrollView.contentView
            
            // remove any existing notification registration
            NotificationCenter.default.removeObserver(self, name: NSView.boundsDidChangeNotification, object: synchronizedContentView)
            
            // set synchronizedScrollView to nil
            self.synchronizedScrollView = nil
        }
    }
}
