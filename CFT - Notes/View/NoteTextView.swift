//
//  NoteTextView.swift
//  CFT - Notes
//
//  Created by Muhamed Niyazov on 14.03.2021.
//  Copyright © 2021 Muhamed Niyazov. All rights reserved.
//

import UIKit

class NoteTextView: UITextView {
    let isEditMode: Bool
    let title: String?
    let mainText: String?
    
    init(_ isEditMode: Bool, _ noteData: Note?) {
        self.isEditMode = isEditMode
        self.title = noteData?.title
        self.mainText = noteData?.mainText
        super.init(frame: CGRect.zero, textContainer: nil)
        configureTextView()
        observersTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTextView(){
        backgroundColor = .secondarySystemBackground
        font = UIFont.systemFont(ofSize: 16)
        tintColor = UIColor.mainRed
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        keyboardDismissMode = .interactive
        isScrollEnabled = true
        showsVerticalScrollIndicator = true

        if !isEditMode {
            becomeFirstResponder()
        } else  {
            let attributedText = NSMutableAttributedString(string: """
                
                \(mainText ?? "")
                """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)])
            let titleBold = NSMutableAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
            
            attributedText.insert(titleBold, at: 0)
            self.attributedText = attributedText
        }
    }
}

//MARK: - Observers
extension NoteTextView {
    
    func observersTextView() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func updateTextView(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentInset = UIEdgeInsets(top: 0, left: 0
                , bottom: 0, right: 0)
        } else {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - 30, right: 10)
        }
    
    }
}

