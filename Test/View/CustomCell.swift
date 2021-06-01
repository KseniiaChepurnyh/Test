//
//  CustomCell.swift
//  Test
//
//  Created by Ксения Чепурных on 01.06.2021.
//

import UIKit
import SnapKit


class CustomCell: UITableViewCell {

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 20)
        label.textColor = .black
        return label
    }()
    
    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 13)
        label.textColor = .darkGray
        return label
    }()
    
    public let differenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 20)
        label.textColor = .darkGray
        return label
    }()
    
    public let arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.up")
        imageView.tintColor = .systemGreen
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(arrowImage)
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(10)
            make.width.height.equalTo(40)
        }
        
        let stak = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stak.axis = .vertical
        stak.spacing = 2
        
        addSubview(stak)
        stak.snp.makeConstraints { make in
            make.centerY.equalTo(arrowImage.snp.centerY)
            make.left.equalTo(arrowImage.snp.right).offset(10)
        }
        
        addSubview(differenceLabel)
        differenceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(arrowImage.snp.centerY)
            make.right.equalTo(self.snp.right).inset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
