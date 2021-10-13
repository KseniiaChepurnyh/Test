//
//  CurrencyDynamicTableViewCell.swift
//  Test
//
//  Created by Ксения Чепурных on 13.10.2021.
//

import UIKit

final class CurrencyDynamicTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties.
    
    private var currencyDynamicView: CurrencyDynamicView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor(
            red: 240/255,
            green: 240/255,
            blue: 245/255,
            alpha: 1
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CurrencyDynamicTableViewCell {
    
    func configureCell(with records: [Record]){
        currencyDynamicView = .init(with: records)
        
        guard let currencyDynamicView = currencyDynamicView else {return }
        currencyDynamicView.layer.cornerRadius = 12
        contentView.addSubview(currencyDynamicView)
        setUpConstraints()
    }

}

private extension CurrencyDynamicTableViewCell {
    
    func setUpConstraints() {
        currencyDynamicView?.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
    }
    
}
