//
//  ListCell.swift
//  CollectionViewSmoothScrollExample(Prefetching)
//
//  Created by David on 06/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    let avatarImageView: UIImageView = {
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dummy"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func configure(_ viewModel: UserViewModel) {
        nameLabel.text = viewModel.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(avatarImageView)
        
        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
}
