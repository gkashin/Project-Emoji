//
//  EmojiTableViewController.swift
//  Project Emoji
//
//  Created by Георгий Кашин on 14/06/2019.
//  Copyright © 2019 Georgii Kashin. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    // MARK: - Stored Propeties
    let cellManager = CellManager()
    var emojis: [[Emoji]]!
    let storageManager = StorageManager()
}

// MARK: - UIViewController Methods
extension EmojiTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// load emojis
        emojis = loadEmojis()
        navigationItem.leftBarButtonItem = editButtonItem
    }
}

// MARK: - UITableView Data Source
extension EmojiTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionName.allCases[section].rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell")!
        guard let emojiCell = cell as? EmojiTableViewCell else { return cell }
        let emoji = emojis[indexPath.section][indexPath.row]
        cellManager.configure(emojiCell, with: emoji)
        return emojiCell
    }
}

// MARK: - UITableView Delegate
extension EmojiTableViewController {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            emojis[indexPath.section].remove(at: indexPath.row)
            if emojis[indexPath.section].isEmpty {
                emojis.remove(at: indexPath.section)
            }
            tableView.reloadData()
        case .insert:
            break
        case .none:
            break
        @unknown default:
            print("UPDATE! New editing styles have appeared!")
        }
    }
}

// MARK: - Model Loading
extension EmojiTableViewController {
    /// Load emojis
    ///
    /// - Returns: two-dimensional array of emojis
    func loadEmojis() -> [[Emoji]] {
        return [
            [
                Emoji(symbol: "👨‍💻", name: "Man-programmer", description: "Very hard programmer", usage: "For man-programmers"),
                Emoji(symbol: "👩‍💻", name: "Woman-programmer", description: "Very lazy programmer", usage: "For woman-programmers")
            ],
            [
                Emoji(symbol: "👨🏿‍💻", name: "Black-man-programmer", description: "Very hard programmer", usage: "For black-man-programmers"),
                Emoji(symbol: "👩🏿‍💻", name: "Black-woman-programmer", description: "Very lazy programmer", usage: "For black-woman-programmers"),
                Emoji(symbol: "👶🏿", name: "Black-child-non-programmer", description: "Very cute", usage: "For black-child-non-programmers")
            ],
            [
                Emoji(symbol: "💻", name: "Laptop", description: "Tool for programmers", usage: "For each programmer")
            ]
        ]
    }
}
