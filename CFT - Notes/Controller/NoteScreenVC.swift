//
//  CreateNoteVC.swift
//  CFT - Notes
//
//  Created by Muhamed Niyazov on 13.03.2021.
//  Copyright © 2021 Muhamed Niyazov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NoteScreenVC: UIViewController, UITextViewDelegate {
    //MARK: - Properties
    let coreDataManager: CoreDataManager
    var noteData: Note?
    var isEditMode: Bool
    
    lazy  var textView: UITextView =  {
        var textview = NoteTextView(self.isEditMode, noteData)
        
        textview.delegate = self
        
        return textview
    }()
    
    //MARK: - Initilization
    init(coreDataManager: CoreDataManager, isEditMode: Bool) {
        self.coreDataManager = coreDataManager
        self.isEditMode = isEditMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        view.backgroundColor = .white
        configureNav()
        configugureUI()
        closeKeyboardButtonConfigure()
    }
    
    // MARK: - Helpers
    func configureNav() {
        let rightBarButtonText = isEditMode ? "" : "Создать"
        let rightBarButton = UIBarButtonItem(title: rightBarButtonText, style: .done, target: self, action: #selector(createNote))
        
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.mainRed
    }
    
    func configugureUI() {
        // textView Settings
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(isEditMode){
            navigationItem.rightBarButtonItem?.title = "Готово"
            isEditMode = true
        }
    }
    
    func closeKeyboardButtonConfigure() {
        textView.inputAccessoryView = CloseKeyboardButton()

        // NotifiСenter for ClosKeyboardButton
        let notifiCenter = NotificationCenter.default
        notifiCenter.addObserver(self, selector: #selector(handleCloseKeyboard), name: NSNotification.Name(rawValue: "closeKeyboard"), object: nil)
    }
    
    func saveNoteInCoreData(title: String, mainText: String) {
        if(!isEditMode) {
            coreDataManager.newNoteInStore(title: title, mainText: mainText) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            coreDataManager.editNoteInStore(beforeTitle: noteData!.title!, title: title, mainText: mainText) {
                navigationItem.rightBarButtonItem!.title = ""
                textView.endEditing(true)
            }
        }
    }
    
    //MARK - Selectors
    @objc func handleCloseKeyboard() {
        textView.endEditing(true)
    }
    
    @objc func createNote() {
        if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let originalText = textView.text!
            let lines = originalText.split(separator:"\n")
            let title = lines.first!
            let mainText = originalText.replacingOccurrences(of: title, with: "",  options: NSString.CompareOptions.literal, range:nil)
            
            saveNoteInCoreData(title: String(title), mainText: mainText)
        }
    }
}
