//
//  CurrenceTableViewCell.swift
//  Test
//
//  Created by Ксения Чепурных on 10.10.2021.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1)
        contentView.addSubview(view)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CurrencyTableViewCell {
    
    func configureCell(witn currency: Currency) {
        titleLabel.text = currency.name
    }
    
}

private extension CurrencyTableViewCell {
    
    func setUpConstraints() {
        
        contentBackgroundView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(5)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
        
        contentBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.trailing.equalTo(contentBackgroundView).inset(16)
        }
    }
    
}
