//
//  CurrencyDynamicHeaderTableViewCell.swift
//  Test
//
//  Created by Ксения Чепурных on 13.10.2021.
//

import UIKit

final class CurrencyDynamicHeaderTableViewCell: UITableViewCell {
    
    // MARK: - UIProperties.
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 100
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.contentMode = .right
        label.text = "Дата"
        return label
    }()
    
    private lazy var cursLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.contentMode = .right
        label.text = "Курс"
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


// MARK: - Constraints.

extension CurrencyDynamicHeaderTableViewCell {
    
    func setUpConstraints() {
        contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(12)
            make.leading.trailing.equalTo(contentView).inset(24)
        }
        
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(cursLabel)
    }
}
