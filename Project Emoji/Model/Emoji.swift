//
//  Emoji.swift
//  Project Emoji
//
//  Created by Георгий Кашин on 14/06/2019.
//  Copyright © 2019 Georgii Kashin. All rights reserved.
//

import Foundation

class Emoji: Codable {
    
    // MARK: - Stored Properties
    var symbol: String
    var name: String
    var description: String
    var type: String
    var usage: String
    
    // MARK: - Computable Properties
    var encoded: Data? {
        let encoder = PropertyListEncoder()
        return try? encoder.encode(self)
    }
    
    // MARK: - Initializers
    convenience init?(from data: Data) {
        let decoder = PropertyListDecoder()
        guard let emoji = try? decoder.decode(Emoji.self, from: data) else { return nil }
        self.init(
            symbol: emoji.symbol,
            name: emoji.name,
            description: emoji.description,
            type: emoji.type,
            usage: emoji.usage
        )
    }
    
    init?(with data: Data) {
        let decoder = PropertyListDecoder()
        guard let emoji = try? decoder.decode(Emoji.self, from: data) else { return nil }
        self.symbol = emoji.symbol
        self.name = emoji.name
        self.description = emoji.description
        self.type = emoji.type
        self.usage = emoji.usage
    }
    
    init(
        symbol: String = "",
        name: String = "",
        description: String = "",
        type: String = "",
        usage: String = ""
    ) {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.type = type
        self.usage = usage
    }
}
