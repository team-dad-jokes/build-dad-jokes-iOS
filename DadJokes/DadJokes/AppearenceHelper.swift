//
//  AppearenceHelper.swift
//  DadJokes
//
//  Created by Thomas Cacciatore on 6/3/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit
import Foundation

enum AppearanceHelper {
    
    static var floridaOrange = UIColor(red: 216.0/255.0, green: 137.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static var backgroundBlue = UIColor(red: 8.0/255.0, green: 0.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    static var customGreen = UIColor(red: 8.0/255.0, green: 200.0/255.0, blue: 8.0/255.0, alpha: 1.0)
    
    static func customFont(with textStyle: UIFont.TextStyle, pointSize: CGFloat) -> UIFont {
        let font = UIFont(name: "Chalkduster", size: pointSize)!
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font) // scales the font
    }
    
    static func setColorAppearance() {
//        UISegmentedControl.appearance().tintColor = floridaOrange
        UINavigationBar.appearance().backgroundColor = backgroundBlue
        UIButton.appearance().tintColor = customGreen
        
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: floridaOrange, NSAttributedString.Key.font: customFont(with: .title1, pointSize: 35)]
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        UISearchBar.appearance().barTintColor = floridaOrange
        //UIView.appearance().backgroundColor = backgroundBlue
        // can't seem to make my UIView background color backgroundBlue! WTF?

    }
}

