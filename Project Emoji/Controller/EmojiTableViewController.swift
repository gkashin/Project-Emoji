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
    let storageManager = StorageManager()
    var sectionsName = [String]()
    var emojis: [[Emoji]]! {
        didSet {
            storageManager.save(emojis: emojis)
        }
    }
}

// MARK: - UIViewController Methods
extension EmojiTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        /// load emojis
        emojis = storageManager.load() ?? loadEmojis()
        /// setup user interface
        setupUI()
    }
}

// MARK: - UI
extension EmojiTableViewController {
    /// setup user interface
    func setupUI() {
        navigationItem.leftBarButtonItem = editButtonItem
        /// fill section name array with emoji type
        for section in emojis {
            sectionsName.append(section.first!.type.lowercased())
        }
    }
}

// MARK: - UITableView Data Source
extension EmojiTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return emojis[section].first?.type
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell")!
        guard let emojiCell = cell as? EmojiTableViewCell else { return cell }
        let emoji = emojis[indexPath.section][indexPath.row]
        /// configure emoji cell with emoji
        cellManager.configure(emojiCell, with: emoji)
        return emojiCell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = emojis[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        /// change type of moved emoji to type of destination type
        movedEmoji.type = sectionsName[destinationIndexPath.section]
        emojis[destinationIndexPath.section].insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
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
                sectionsName.remove(at: indexPath.section)
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
                Emoji(symbol: "👨‍💻", name: "Man-programmer", description: "Very hard programmer", type: "Programmers", usage: "For man-programmers"),
                Emoji(symbol: "👩‍💻", name: "Woman-programmer", description: "Very lazy programmer", type: "Programmers", usage: "For woman-programmers")
            ],
            [
                Emoji(symbol: "👨🏿‍💻", name: "Black-man-programmer", description: "Very hard programmer", type: "Black-programmers", usage: "For black-man-programmers"),
                Emoji(symbol: "👩🏿‍💻", name: "Black-woman-programmer", description: "Very lazy programmer", type: "Black-programmers", usage: "For black-woman-programmers"),
                Emoji(symbol: "👶🏿", name: "Black-child-non-programmer", description: "Very cute", type: "Black-programmers", usage: "For black-child-non-programmers")
            ],
            [
                Emoji(symbol: "💻", name: "Laptop", description: "Tool for programmers", type: "Tools", usage: "For each programmer")
            ]
        ]
    }
}

// MARK: - Navigation
extension EmojiTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditEmojiSegue" else { return }
        let destination = segue.destination as! EmojiDetailTableViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        /// pass data to destination
        destination.title = "Edit"
        destination.emoji = emojis[indexPath.section][indexPath.row]
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveEmojiSegue" else { return }
        let source = segue.source as! EmojiDetailTableViewController
        let emoji = source.emoji
        if let indexPath = tableView.indexPathForSelectedRow {
            // edit emoji
            var section: Int?
            /// check if there is such emoji type
            section = sectionsName.firstIndex(of: emoji.type.lowercased())
            /// if such section exists
            if let section = section {
                /// check if it is the same section
                if section == indexPath.section {
                    /// update information about emoji
                    emojis[section][indexPath.row] = emoji
                    tableView.reloadData()
                } else {
                    /// remove emoji from old section
                    emojis[indexPath.section].remove(at: indexPath.row)
                    let row = emojis[section].count
                    /// insert emoji to new section
                    emojis[section].insert(emoji, at: row)
                    
                    /// if it is the last row in section
                    if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                        /// update information about section name
                        sectionsName.remove(at: indexPath.section)
                        sectionsName.append(emoji.type.lowercased())
                    }
                    tableView.reloadData()
                }
            /// if such section does not exist
            } else {
                /// if it is the last row in section
                if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                    /// update information about emoji and section name
                    sectionsName[indexPath.section] = emoji.type.lowercased()
                    emojis[indexPath.section] = [emoji]
                } else {
                    /// remove emoji from old section
                    emojis[indexPath.section].remove(at: indexPath.row)
                    /// create a new section with emoji
                    emojis.append([emoji])
                    /// add new section name
                    sectionsName.append(emoji.type.lowercased())
                }
                tableView.reloadData()
            }
        } else {
            // add emoji
            var section: Int?
            /// check if there is such emoji type
            section = sectionsName.firstIndex(of: emoji.type.lowercased())
            /// if such section exists
            if let section = section {
                /// add new emoji to existing section
                let indexPath = IndexPath(row: emojis[section].count, section: section)
                emojis[section].insert(emoji, at: indexPath.row)
                tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
                /// create a new section
                emojis.append([emoji])
                /// add new section name
                sectionsName.append(emoji.type)
                
                tableView.reloadData()
            }
        }
    }
}
