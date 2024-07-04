//
//  UIImage+Crop.swift
//  DSZPhotoCropEditor
//
//  Created by Apple on 2018/8/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension UIImage {
    func rotatedImageWithTransform(rect: CGRect) -> UIImage {
        
        let origin = CGPoint(x: -rect.origin.x, y: -rect.origin.y)
        var img : UIImage?
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale);
        draw(at: origin)
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img!
    }
}
