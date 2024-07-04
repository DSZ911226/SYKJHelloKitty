//
//  CropView.swift
//  DSZPhotoCropEditor
//
//  Created by Apple on 2018/8/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import AVFoundation

let SCREEN_HEIGHT = UIScreen.main.bounds.height
let SCREEN_WIDTH = UIScreen.main.bounds.width


open class CropView: UIView, UIGestureRecognizerDelegate, CropRectViewDelegate {
    open var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    //    裁剪比例大小
    open var cropAspectRatio: CGFloat = 0.0
    //    显示裁剪区域
    open var showCroppedArea = true {
        didSet {
            layoutIfNeeded()
            showOverlayView(showCroppedArea)
        }
    }
    open var croppedImage: UIImage? {
        let scale = (image?.size.width)!/(orginalFrame?.width)!
        
        
        return image?.rotatedImageWithTransform(rect: CGRect(x: ((finalFrame?.origin.x)! - (orginalFrame?.origin.x)!) * scale, y: ((finalFrame?.origin.y)! - (orginalFrame?.origin.y)!) * scale, width: (finalFrame?.width)! * scale, height: (finalFrame?.height)! * scale))
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate let cropRectView = CropRectView()
    fileprivate let topOverlayView = UIView()
    fileprivate let leftOverlayView = UIView()
    fileprivate let rightOverlayView = UIView()
    fileprivate let bottomOverlayView = UIView()
    fileprivate var resizing = false
    fileprivate var orginalFrame : CGRect?
    fileprivate var finalFrame : CGRect?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    //初始化
    fileprivate func initialize() {
        backgroundColor = .yellow
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        cropRectView.delegate = self
        addSubview(cropRectView)
        
        showOverlayView(showCroppedArea)
        addSubview(topOverlayView)
        addSubview(leftOverlayView)
        addSubview(rightOverlayView)
        addSubview(bottomOverlayView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setImageViewSize()
        
    }
    
    
    //设置imageView大小
    fileprivate func setImageViewSize(){
        
        
        if !resizing {
            let imageWith = SCREEN_WIDTH - 20.0
            let imageHeight = SCREEN_HEIGHT - 100.0
            
            let scaleImage = (image?.size.width)!/(image?.size.height)!
            let scaleImageView = imageWith/imageHeight
            
            
            if scaleImage > scaleImageView  {
                imageView.frame = CGRect(x: 0, y: 0, width: imageWith, height: imageWith/scaleImage)
            } else {
                imageView.frame = CGRect(x: 0, y: 0, width: imageHeight * scaleImage, height: imageHeight)
            }
            
            imageView.center = center
            orginalFrame = imageView.frame
            
            var frame = imageView.frame
            if cropAspectRatio != 0 {
                let width = frame.height * cropAspectRatio
                let height = frame.width / cropAspectRatio
                
                if width > frame.width {
                    frame.size = CGSize(width: frame.width, height: height)
                }else {
                    frame.size = CGSize(width: width, height: frame.height)
                }
            }
            layoutCropRectViewWithCropRect(cappedCropRectInImageRectWithCropRectView(frame))
            finalFrame = cropRectView.frame
            resizing = true
        }
    }
    
    //    // MARK: - Private methods  显示覆盖View
    fileprivate func showOverlayView(_ show: Bool) {
        let color = show ? UIColor(white: 0.0, alpha: 0.4) : UIColor.clear
        
        topOverlayView.backgroundColor = color
        leftOverlayView.backgroundColor = color
        rightOverlayView.backgroundColor = color
        bottomOverlayView.backgroundColor = color
    }
    
    //    // MARK: - CropView delegate methods
    func cropRectViewDidBeginEditing(_ view: CropRectView) {
    }
    
    func cropRectViewDidChange(_ view: CropRectView,_ state: NSInteger) {
        var cropRect = view.frame
        if state != 5 {
            cropRect = cappedCropRectInImageRectWithCropRectView(view.frame)
        }else {
            cropRect = dragCropRectInImageRectWithCropRectView(view.frame)
        }
        cropRect = cappedCropRectInImageRectWithCropRectViewForScale(cropRect, state)
        layoutCropRectViewWithCropRect(cropRect)
    }
    
    func cropRectViewDidEndEditing(_ view: CropRectView) {
        finalFrame = view.frame
    }
    
    fileprivate func cappedCropRectInImageRectWithCropRectView(_ cropRectFrame: CGRect) -> CGRect {
        var cropRect = cropRectFrame
        if (orginalFrame?.minX)! > cropRect.minX {
            var cappedWidth = cropRect.maxX
            cropRect.origin.x = (orginalFrame?.minX)!
            cappedWidth = cappedWidth - cropRect.origin.x
            let height = cropRect.size.height
            cropRect.size = CGSize(width: cappedWidth, height: height)
        }
        
        if (orginalFrame?.minY)! > cropRect.minY {
            var cappedHeight = cropRect.maxY
            cropRect.origin.y = (orginalFrame?.minY)!
            cappedHeight = cappedHeight - cropRect.origin.y
            let width = cropRect.size.width
            cropRect.size = CGSize(width: width, height: cappedHeight)
        }
        if (orginalFrame?.maxX)! < cropRect.maxX {
            let cappedWidth = (orginalFrame?.maxX)! - cropRect.minX
            let height = cropRect.size.height
            cropRect.size = CGSize(width: cappedWidth, height: height)
        }
        if (orginalFrame?.maxY)! < cropRect.maxY {
            let cappedHeight = (orginalFrame?.maxY)! - cropRect.minY
            let width = cropRect.size.width
            cropRect.size = CGSize(width: width, height: cappedHeight)
        }
        
        
        
        
        return cropRect
    }
    
    
    fileprivate func dragCropRectInImageRectWithCropRectView(_ cropRectFrame: CGRect) -> CGRect {
        var cropRect = cropRectFrame
        if (orginalFrame?.minX)! > cropRect.minX {
            cropRect.origin.x = (orginalFrame?.minX)!
        }
        
        if (orginalFrame?.minY)! > cropRect.minY {
            cropRect.origin.y = (orginalFrame?.minY)!
        }
        if (orginalFrame?.maxX)! < cropRect.maxX {
            
            cropRect.origin.x = (orginalFrame?.maxX)! - cropRect.size.width
        }
        if (orginalFrame?.maxY)! < cropRect.maxY {
            cropRect.origin.y = (orginalFrame?.maxY)! - cropRect.size.height
        }
        
        return cropRect
    }
    
    
    fileprivate func cappedCropRectInImageRectWithCropRectViewForScale(_ cropRectFrame: CGRect ,_ state: NSInteger) -> CGRect {
        var cropRect = cropRectFrame
        if cropAspectRatio != 0 {
            var width = cropRect.height * cropAspectRatio
            var height = cropRect.width / cropAspectRatio
            if width > cropRect.width {
                width = cropRect.width
            }else {
                height = cropRect.height
            }
            if state == 1 {
                cropRect = CGRect(x: cropRect.maxX - width, y: cropRect.maxY - height, width: width, height: height)
            }else if state == 2 {
                cropRect = CGRect(x: cropRect.origin.x, y: cropRect.maxY - height, width: width, height: height)
            }else if state == 3 {
                cropRect = CGRect(x: cropRect.maxX - width, y: cropRect.origin.y, width: width, height: height)
            }else if state == 4 {
                cropRect = CGRect(x: cropRect.origin.x, y: cropRect.origin.y, width: width, height: height)
            }else if state == 5 {
                cropRect = CGRect(x: cropRect.origin.x, y: cropRect.origin.y, width: width, height: height)
            }
        }
        
        return cropRect
    }
    
    fileprivate func layoutCropRectViewWithCropRect(_ cropRect: CGRect) {
        cropRectView.frame = cropRect
        layoutOverlayViewsWithCropRect(cropRect)
    }
    
    fileprivate func layoutOverlayViewsWithCropRect(_ cropRect: CGRect) {
        topOverlayView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: cropRect.minY)
        leftOverlayView.frame = CGRect(x: 0, y: cropRect.minY, width: cropRect.minX, height: cropRect.height)
        rightOverlayView.frame = CGRect(x: cropRect.maxX, y: cropRect.minY, width: bounds.width - cropRect.maxX, height: cropRect.height)
        bottomOverlayView.frame = CGRect(x: 0, y: cropRect.maxY, width: bounds.width, height: bounds.height - cropRect.maxY)
    }
    
}
