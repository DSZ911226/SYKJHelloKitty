//
//  CropViewController.swift
//  DSZPhotoCropEditor
//
//  Created by Apple on 2018/8/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

public protocol CropViewControllerDelegate: class {
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage)
    func cropViewControllerDidCancel(_ controller: CropViewController)
}

open class CropViewController: UIViewController {
    open weak var delegate: CropViewControllerDelegate?
    open var image: UIImage? {
        didSet {
            cropView?.image = image!
        }
    }
    
    open var cropAspectRatio: CGFloat? = 0.0{
        didSet {
            cropView?.cropAspectRatio = cropAspectRatio!
        }
    }
    
    fileprivate var cropView: CropView?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    fileprivate func initialize() {
    }
    
    open override func loadView() {
        let contentView = UIView()
        contentView.autoresizingMask = .flexibleWidth
        contentView.backgroundColor = UIColor.black
        view = contentView
        // Add CropView
        cropView = CropView(frame: contentView.bounds)
        contentView.addSubview(cropView!)
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.toolbar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CropViewController.cancel(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CropViewController.done(_:)))
        cropView?.image = image!
        cropView?.cropAspectRatio = cropAspectRatio!
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.cropViewControllerDidCancel(self)
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        if let image = cropView?.croppedImage {
            delegate?.cropViewController(self, didFinishCroppingImage: image)
            
            
        }
    }
    
    
    
    
    
    
}
