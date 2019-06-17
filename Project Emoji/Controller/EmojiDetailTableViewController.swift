//
//  EmojiDetailTableViewController.swift
//  Project Emoji
//
//  Created by Георгий Кашин on 16/06/2019.
//  Copyright © 2019 Georgii Kashin. All rights reserved.
//

import UIKit

class EmojiDetailTableViewController: UITableViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    
    // MARK: - Stored Properties
    var emoji = Emoji()
    
    // MARK: - IB Actions
    @IBAction func textEditingChanged() {
        updateUI()
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        /// setup text fields
        symbolTextField.text = emoji.symbol
        nameTextField.text = emoji.name
        descriptionTextField.text = emoji.description
        typeTextField.text = emoji.type
        usageTextField.text = emoji.usage
        /// update user interface
        updateUI()
    }
}

// MARK: - UI
extension EmojiDetailTableViewController {
    /// update user interface
    func updateUI() {
        saveBarButton.isEnabled = symbolTextField.text?.count == 1
            && !nameTextField.text!.isEmpty
            && !descriptionTextField.text!.isEmpty
            && !typeTextField.text!.isEmpty
            && !usageTextField.text!.isEmpty
    }
}

// MARK: - UITableView Delegate
extension EmojiDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 88
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Navigation
extension EmojiDetailTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveEmojiSegue" else { return }
        /// configure emoji
        emoji.symbol = symbolTextField.text!
        emoji.name = nameTextField.text!
        emoji.description = descriptionTextField.text!
        emoji.type = typeTextField.text!
        emoji.usage = usageTextField.text!
    }
}
