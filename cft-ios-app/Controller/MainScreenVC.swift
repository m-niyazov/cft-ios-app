//
//  NotesVC.swift
//  CFT - Notes
//
//  Created by Muhamed Niyazov on 12.03.2021.
//  Copyright © 2021 Muhamed Niyazov. All rights reserved.
//

import UIKit
import CoreData

class MainScreenVC: UITableViewController {
    //MARK: - Properties
    var coreDataManager: CoreDataManager
    var notes: [Note] = []
    
    //MARK: - Initilization
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NoteCell.self, forCellReuseIdentifier: "NoteCell")
        
        configureNavigationBar()
        view.backgroundColor = .secondarySystemBackground
 
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreDataManager.getNotesFromStore { (notes) in
            self.notes = notes
        }
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    func configureNavigationBar() {
        title = "ЦФТ - Заметки"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainRed, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
        
        let backBarItem = UIBarButtonItem()
        backBarItem.title = self.title
        backBarItem.tintColor = UIColor.mainRed
        
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushToCreateNoteVC))
        rightBarItem.tintColor = UIColor.mainRed
        
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = rightBarItem
        navigationItem.backBarButtonItem = backBarItem
    }
    
    //MARK: - Selectors
    @objc func pushToCreateNoteVC() {
        let createNoteVC = NoteScreenVC(coreDataManager: coreDataManager, isEditMode: false)
        navigationController?.pushViewController(createNoteVC, animated: true)
    }
}

// MARK: - TableView DataDource
extension MainScreenVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.textLabel?.text = note.title
        let clearMainText = note.mainText?.replacingOccurrences(of: "\n", with: "",  options: NSString.CompareOptions.literal, range: nil)
        cell.detailTextLabel?.text  = clearMainText
        return cell
    }
}

// MARK: - TableView Actions
extension MainScreenVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createNoteVC = NoteScreenVC(coreDataManager: coreDataManager, isEditMode: true )
        createNoteVC.noteData = notes[indexPath.row]
        navigationController?.pushViewController(createNoteVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить", handler: { (action, view, success) in
            self.coreDataManager.removeNoteFromStore(indexPath: indexPath) {
                self.notes.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        })
        deleteAction.backgroundColor = .mainRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
