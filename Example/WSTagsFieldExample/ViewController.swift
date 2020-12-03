//
//  ViewController.swift
//  WSTagsFieldExample
//
//  Created by Ricardo Pereira on 04/07/16.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import UIKit
import WSTagsField

class ViewController: UIViewController {

    fileprivate let tagsField = CustomWSTagsField()

    @IBOutlet fileprivate weak var tagsView: UIView!
    @IBOutlet weak var anotherField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)

        //tagsField.translatesAutoresizingMaskIntoConstraints = false
        //tagsField.heightAnchor.constraint(equalToConstant: 150).isActive = true

        
        tagsField.cornerRadius = 12
        tagsField.spaceBetweenLines = 4
        tagsField.spaceBetweenTags = 4
        tagsField.layoutMargins = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        tagsField.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)

        tagsField.placeholder = "Enter a tag"
        tagsField.placeholderColor = .darkGray
        tagsField.placeholderAlwaysVisible = true
        tagsField.backgroundColor = .white
        tagsField.textField.returnKeyType = .continue
        tagsField.delimiter = ""
        
        tagsField.tagColor = .init(red: 208/255, green: 230/255, blue: 255/255, alpha: 1)
        tagsField.tintColor = .init(red: 208/255, green: 230/255, blue: 255/255, alpha: 1)
        tagsField.textColor = .black
        tagsField.selectedColor = .init(red: 176/255, green: 195/255, blue: 216/255, alpha: 1)
        tagsField.selectedTextColor = .black
        tagsField.configureTagView = { tagView in
            guard let tagView = tagView as? CustomWSTagView else { return }
            tagView.readonlyColor = .blue
            tagView.readonlyTextColor = .black
            tagView.tagColor = .init(red: 208/255, green: 230/255, blue: 255/255, alpha: 1)
        }
        tagsField.forceTextFieldOnNewLine = true
        
        tagsField.font = .systemFont(ofSize: 12)

        tagsField.textDelegate = self

        textFieldEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagsField.beginEditing()
        
        let tag1 = WSTag("Nuno Grilo", context: UUID().uuidString)
        tagsField.addTag(tag1)
        let tag2 = WSTag("Alan Roger", context: UUID().uuidString)
        tagsField.addTag(tag2)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsField.frame = tagsView.bounds
    }

    @IBAction func touchReadOnly(_ sender: UIButton) {
        tagsField.readOnly = !tagsField.readOnly
        sender.isSelected = tagsField.readOnly
    }

    @IBAction func touchChangeAppearance(_ sender: UIButton) {
        tagsField.cornerRadius = 12
        tagsField.spaceBetweenLines = 4
        tagsField.spaceBetweenTags = 4
        tagsField.layoutMargins = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        tagsField.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
        
        tagsField.tintColor = .red
        tagsField.textColor = .blue
        tagsField.selectedColor = .yellow
        tagsField.selectedTextColor = .black
        tagsField.delimiter = ","
        tagsField.isDelimiterVisible = true
        tagsField.borderWidth = 2
        tagsField.borderColor = .blue
        tagsField.textField.textColor = .green
        tagsField.placeholderColor = .green
        tagsField.placeholderAlwaysVisible = false
        tagsField.font = UIFont.systemFont(ofSize: 9)
        tagsField.keyboardAppearance = .dark
        tagsField.acceptTagOption = .space
    }

    @IBAction func touchAddRandomTags(_ sender: UIButton) {
//        tagsField.addTag(NSUUID().uuidString)
//        tagsField.addTag(NSUUID().uuidString)
//        tagsField.addTag(NSUUID().uuidString)
//        tagsField.addTag(NSUUID().uuidString)
        let tag = WSTag("Nuno Grilo", context: UUID().uuidString)
        tagsField.addTag(tag)
    }

    @IBAction func touchTableView(_ sender: UIButton) {
        present(UINavigationController(rootViewController: TableViewController()), animated: true, completion: nil)
    }

}

extension ViewController {

    fileprivate func textFieldEvents() {
        tagsField.onDidAddTag = { field, tag in
            //print("onDidAddTag", tag.text)
            print("onDidAddTag: \(tag.text) - context=\(tag.context)")
        }

        tagsField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
        }

        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")
        }

        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }

        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }

        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }

        tagsField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
    }

}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagsField {
            anotherField.becomeFirstResponder()
        }
        return true
    }

}
