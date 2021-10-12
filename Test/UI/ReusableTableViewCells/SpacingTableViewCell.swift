//
//  SpacingTableViewCell.swift
//  Test
//
//  Created by Ксения Чепурных on 12.10.2021.
//

import UIKit

final class SpacingTableViewCell: UITableViewCell {
    
    // MARK: - Initialization.
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
