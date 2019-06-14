//
//  CellManager.swift
//  Project Emoji
//
//  Created by Георгий Кашин on 14/06/2019.
//  Copyright © 2019 Georgii Kashin. All rights reserved.
//

import Foundation

class CellManager {
    /// Configure cell with emoji
    ///
    /// - Parameters:
    ///   - cell: emoji cell
    ///   - emoji: instance of Emoji class
    func configure(_ cell: EmojiTableViewCell, with emoji: Emoji) {
        cell.symbolLabel.text = emoji.symbol
        cell.nameLabel.text = emoji.name
        cell.descriptionLabel.text = emoji.description
    }
}
