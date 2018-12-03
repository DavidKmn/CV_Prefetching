//
//  ConstantsManager.swift
//  CollectionViewSmoothScrollExample(Prefetching)
//
//  Created by David on 06/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class ConstantsManager {
    
    private init() {}
    
    static let shared = ConstantsManager()
    
    var rootApiUrlString: String {
        
        var dictRoot: NSDictionary?
        
        let path = Bundle.main.path(forResource: "API_LINKS", ofType: "plist")
        dictRoot = NSDictionary(contentsOfFile: path!)
        return dictRoot?["rootUrl"] as! String
    }
}
