//
//  CurrenceTableViewCell.swift
//  Test
//
//  Created by Ксения Чепурных on 10.10.2021.
//

import UIKit

enum CurrencyTableViewCellType {
    case selected
    case notSelected
}

final class CurrencyTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties.
    
    private lazy var contentBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
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
    
    private lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "checkMark")
        return imageView
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


// MARK: - Configure Cell.

extension CurrencyTableViewCell {
    
    func configureCell(witn currency: Currency, type: CurrencyTableViewCellType) {
        titleLabel.text = currency.name
        switch type {
        case .selected:
            contentBackgroundView.backgroundColor = UIColor(
                red: 235/255,
                green: 244/255,
                blue: 234/255,
                alpha: 1
            )
            checkMarkImageView.isHidden = false
        case .notSelected:
            contentBackgroundView.backgroundColor = UIColor(
                red: 240/255,
                green: 240/255,
                blue: 245/255,
                alpha: 1
            )
            checkMarkImageView.isHidden = true
        }
    }
    
}


// MARK: - Constraints.

private extension CurrencyTableViewCell {
    
    func setUpConstraints() {
        
        contentBackgroundView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(5)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
        
        contentBackgroundView.addSubview(checkMarkImageView)
        checkMarkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentBackgroundView.snp.centerY)
            make.trailing.equalTo(contentBackgroundView).inset(16)
            make.width.height.equalTo(20)
        }
        
        contentBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentBackgroundView.snp.centerY)
            make.leading.equalTo(contentBackgroundView).offset(16)
            make.trailing.equalTo(checkMarkImageView).inset(16)
        }
    }
    
}
