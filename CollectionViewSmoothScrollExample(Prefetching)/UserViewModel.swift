//
//  UserViewModel.swift
//  CollectionViewSmoothScrollExample(Prefetching)
//
//  Created by David on 06/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

struct User: Codable {
    let avatarImageUrl: String
    let name: String
    
    init(avatarImageUrl: String, name: String) {
        self.avatarImageUrl = avatarImageUrl
        self.name = name
    }
}

struct UserViewModel {
    let avatarImageUrl: String
    let name: String
    
    init(user: User) {
        avatarImageUrl = user.avatarImageUrl
        name = user.name
    }
}
