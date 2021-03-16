//
//  NoteCell.swift
//  CFT - Notes
//
//  Created by Muhamed Niyazov on 13.03.2021.
//  Copyright © 2021 Muhamed Niyazov. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    //MARK: - Properties
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .secondarySystemBackground
        textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
    }

  

}
