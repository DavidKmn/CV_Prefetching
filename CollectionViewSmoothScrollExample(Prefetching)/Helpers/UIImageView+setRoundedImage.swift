//
//  UIImageView+setRoundedImage.swift
//  CollectionViewSmoothScrollExample(Prefetching)
//
//  Created by David on 06/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRoundedImage(_ image: UIImage?) {
        guard let image = image else { return }
        DispatchQueue.main.async {
            self.image = image
            self.roundCorners(withRadius: 10)
        }
    }
}

private extension UIImageView {
    func roundCorners(withRadius radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}
