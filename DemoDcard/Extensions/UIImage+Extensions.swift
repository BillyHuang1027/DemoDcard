//
//  UIImage+Extensions.swift
//  DemoDcard
//
//  Created by 黃昌齊 on 2021/5/7.
//

import Foundation
import UIKit

extension UIImage {
    static func image(from url: URL, handel: @escaping (UIImage?) -> ()) {
        guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            handel(nil)
            return
        }
        handel(image)
    }
    
    func scaled(with scale: CGFloat) -> UIImage? {
        let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
