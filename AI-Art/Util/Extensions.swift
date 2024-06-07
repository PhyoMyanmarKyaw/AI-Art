//
//  Extensions.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import UIKit

extension UIImage {
    convenience init?(cgImage: CGImage) {
        self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
    }
}
