//
//  LoadImageOperation.swift
//  CollectionViewSmoothScrollExample(Prefetching)
//
//  Created by David on 06/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

typealias LoadImageOperationCompletionHandler = (UIImage) -> Void

class LoadImageOperation: Operation {
    
    private var url: String
    var completionHandler: LoadImageOperationCompletionHandler?
    var image: UIImage?
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        if isCancelled { return }
        
        UIImage.downloadImageFromUrl(url, completionHandler: { [weak self] (img) in
            guard let self = self, !(self.isCancelled), let image = img else { return }
            self.image = image
            self.completionHandler?(image)
        })
    }
}
