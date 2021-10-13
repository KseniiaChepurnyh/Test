//
//  ContentSizedTableView.swift
//  Test
//
//  Created by Ксения Чепурных on 13.10.2021.
//

import UIKit

final class ContentSizedTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
}
