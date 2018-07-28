//
//  ViewController.swift
//  ImageCropper
//
//  Created by Rudolf Farkas on 24.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import UIKit


extension CGFloat {
    var fmt: String { return String(format: "%.3g", self) }
}

extension CGPoint {
    var fmt: String { return String(format: "(%.2f, %.2f)", self.x, self.y) }
}

extension CGSize {
    var fmt: String { return String(format: "(%.2f, %.2f)", self.width, self.height) }

    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width * scalar, height: size.height * scalar)
    }

    static func * (size: CGSize, scalar: Double) -> CGSize {
        return size * CGFloat(scalar)
    }

    static func / (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width / scalar, height: size.height / scalar)
    }

    static func / (size: CGSize, scalar: Double) -> CGSize {
        return size / CGFloat(scalar)
    }
}

extension CGRect {
    var fmt: String { return origin.fmt + size.fmt }
}


class ViewController: UIViewController {
    
    var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            scrollView.contentOffset = CGPoint()
            updateScrollViewScales()
            centerScrollViewContents()
        }
    }
    
    
    // outlets
    
    @IBOutlet weak var croppedImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            print("-  scrollView didSet")
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    
    @IBOutlet weak var loadImage: UIButton!
    @IBOutlet weak var cropAndShow: UIButton!
    @IBOutlet weak var cropAndSave: UIButton!
    
    // actions
    
    @IBAction func loadImageTap(_ sender: Any) {
        print("loadImage")
        presentImagePicker()
    }
    
    @IBAction func cropAndShowTap(_ sender: Any) {
        print("cropAndShow")
        croppedImageView.image = croppedImage()
    }
    
    @IBAction func cropAndSaveTap(_ sender: Any) {
        print("cropAndSave")
        
        croppedImageView.image = croppedImage() // show
        UIImageWriteToSavedPhotosAlbum(croppedImageView.image!, nil, nil, nil) // save to pictures
        
        let alert = UIAlertController(title: "image saved", message: "image saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // controller startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        scrollView.contentMode = .scaleAspectFit
        
        let image = (UIImage(named: "IMG_2616")!)
        print("viewDidLoad image.size= \(image.size.fmt)")
        
        self.image = image
        croppedImageView.contentMode = .scaleAspectFit
        printScales("viewDidLoad")
    }
    
    // helpers
    
    fileprivate func croppedImage() -> UIImage {
        let size = scrollView.bounds.size / scrollView.zoomScale
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        print("cropAndSave scrollView.size=\(scrollView.bounds.size) scrollView.offset=\(scrollView.contentOffset) scale=\(UIScreen.main.scale)")
        
        
        let offset = scrollView.contentOffset
        let origin = CGPoint(x: -offset.x, y: -offset.y)

        imageView.image?.draw(at: origin)
        let cropped = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        print("cropAndSave cropped.size=\(String(describing: cropped?.size.fmt))")

        return cropped!
    }
    
    
    func presentImagePicker() {
        printScales("presentImagePicker")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func centerScrollViewContents() {
        imageView.frame.origin.x = max(0, (scrollView.bounds.size.width - imageView.frame.size.width) / 2)
        imageView.frame.origin.y = max(0, (scrollView.bounds.size.height - imageView.frame.size.height) / 2)
    }
    
    fileprivate func updateScrollViewScales() {
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = 1
    }
    
    fileprivate func printScales(_ caller: String) {
        print("")
        print("\(caller) printScales imageView.contentMode=\(imageView.contentMode.rawValue)", "scrollView.contentMode=\(scrollView.contentMode.rawValue)")
        print("\(caller) printScales scrollView.zoomScale=\(scrollView.zoomScale) min=\(scrollView.minimumZoomScale) max=\(scrollView.maximumZoomScale)")
        //        print("\(caller) printScales scrollView.contentOffset=\(scrollView.contentOffset) center= \(scrollView.center)")
        print("\(caller) printScales imageView.frame=\(imageView.frame.fmt)")
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
        
        print("scrollViewDidZoom", "contentSize=", scrollView.contentSize.fmt,  "contentOffset=", scrollView.contentOffset.fmt, "zoomScale=", scrollView.zoomScale.fmt)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("scrollViewDidScroll", "contentSize=", scrollView.contentSize.fmt,  "contentOffset=", scrollView.contentOffset.fmt, "zoomScales= \(scrollView.zoomScale.fmt) ( \(scrollView.minimumZoomScale.fmt)...\(scrollView.maximumZoomScale.fmt) )")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController:  UINavigationControllerDelegate {
    
}

