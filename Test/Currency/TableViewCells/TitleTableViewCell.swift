//
//  TitleTableViewCell.swift
//  Test
//
//  Created by Ксения Чепурных on 11.10.2021.
//

import UIKit


final class TitleTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties.
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 27, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization.
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleTableViewCell {
    
    func configureCell(with text: String) {
        titleLabel.text = text
    }
    
}


// MARK: - Constraints.

private extension TitleTableViewCell {
    
    func setUpConstraints() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
    }
    
}
