//
//  Extension.swift
//  ShuweiGan_Lab3
//
//  Created by 甘书玮 on 2022/10/6.
//

import Foundation
import UIKit

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
}

//reference:https://blog.csdn.net/weixin_33958366/article/details/92507323?spm=1001.2101.3001.6650.3&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-3-92507323-blog-109643483.pc_relevant_3mothn_strategy_and_data_recovery&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-3-92507323-blog-109643483.pc_relevant_3mothn_strategy_and_data_recovery&utm_relevant_index=6

extension Double{
    func roundTo(p:Int) -> Double {
        let divisor = pow(10.0, Double(p))
        return (self*divisor).rounded()/divisor
    }
}
