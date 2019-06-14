//
//  Emoji.swift
//  Project Emoji
//
//  Created by Георгий Кашин on 14/06/2019.
//  Copyright © 2019 Georgii Kashin. All rights reserved.
//

import Foundation

class Emoji {
    
    // MARK: - Stored Properties
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    // MARK: - Initializers
    init(symbol: String, name: String, description: String, usage: String) {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
    }
}
