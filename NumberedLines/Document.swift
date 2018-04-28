//
//  Document.swift
//  NumberedLines
//
//  Created by Michael Dautermann on 4/25/18.
//  Copyright © 2018 Michael Dautermann. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    var viewController : ViewController?
    var documentContent : String?
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }
    
    override func data(ofType typeName: String) throws -> Data {
        // since NSDocument returns a non-optional,
        // we should return something, even if it's nothing
        var data = Data()
        
        if let rawString = self.viewController?.nlTextView.string
        {
            if let rawData = rawString.data(using: .utf8)
            {
                data = rawData
            }
        } else {
            // if I had more time to do this I'd return and/or display a much more specific error
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
        return data
    }

    override func read(from data: Data, ofType typeName: String) throws {
        documentContent = String(decoding: data, as: UTF8.self)
    }

}

