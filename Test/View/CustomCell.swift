//
//  CustomCell.swift
//  Test
//
//  Created by Ксения Чепурных on 01.06.2021.
//

import UIKit
import SnapKit

struct CustomCellViewModel {
    let value: String
    let date: String
    let difference: String
}

//enum CellType {
//
//}

class CustomCell: UITableViewCell {
    
    private lazy var titleAndSubtitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 20)
        label.textColor = .black
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 13)
        label.textColor = .darkGray
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var differenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 20)
        label.textColor = .darkGray
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGreen
        contentView.addSubview(imageView)
        return imageView
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


extension CustomCell {
    
    func configureCell(with model: CustomCellViewModel) {
        titleLabel.text = model.value
        subtitleLabel.text = model.date
        
        
    }
    
}

private extension CustomCell {
    
    func setUpConstraints() {
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(10)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(titleAndSubtitleStackView)
        titleAndSubtitleStackView.snp.makeConstraints { make in
            make.centerY.equalTo(arrowImage.snp.centerY)
            make.left.equalTo(arrowImage.snp.right).offset(10)
        }
        
        differenceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(arrowImage.snp.centerY)
            make.right.equalTo(self.snp.right).inset(10)
        }
    }
    
}
