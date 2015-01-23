//
//  NSImage.swift
//  Weather
//
//  Created by student on 20.01.15.
//  Copyright (c) 2015 student. All rights reserved.
//

import UIKit

class NSImage : NSObject, NSCopying, NSCoding, NSSecureCoding, NSPasteboardReading, NSObjectProtocol, NSPasteboardWriting {
    
    /*All instance variables are private*/
    
    init?(named name: String) -> NSImage /* If this finds & creates the image, only name is saved when archived */
    
    init(size aSize: NSSize)
    init?(data: NSData) /* When archived, saves contents */
    init?(contentsOfFile fileName: String) /* When archived, saves contents */
    init?(contentsOfURL url: NSURL) /* When archived, saves contents */
    init?(byReferencingFile fileName: String) /* When archived, saves fileName */
    init(byReferencingURL url: NSURL) /* When archived, saves url, supports progressive loading */
    
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
}
