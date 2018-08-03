//
//  ViewController.swift
//  ImageCropper
//
//  Created by Rudolf Farkas on 24.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // outlets
    
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var croppedImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var loadImage: UIButton!
    @IBOutlet weak var cropAndShow: UIButton!
    @IBOutlet weak var cropAndSave: UIButton!
    
    // actions

    @IBAction func scrollViewTap(_ sender: UITapGestureRecognizer) {
        print("   imageViewTap", _scrollInfo)
    }

    @IBAction func loadImageTap(_ sender: Any) {
        print("loadImage")
        presentImagePicker()
    }
    
    @IBAction func cropAndShowTap(_ sender: Any) {
        print("cropAndShow")
        croppedImageView.image = getCroppedImage()
    }

    @IBAction func cropAndSaveTap(_ sender: Any) {
        print("cropAndSave")

        let croppedImage = getCroppedImage()
        croppedImageView.image = getCroppedImage()
        saveImageToPhotos(croppedImage)
    }

    // private methods

    private var _zoomScaleInfo: String {
        let sv = scrollView!
        return "minimumZoomScale=\(sv.minimumZoomScale.fmt)  maximumZoomScale=\(sv.maximumZoomScale.fmt)  zoomScale=\(sv.zoomScale.fmt)"
    }

    private var _scrollInfo: String {
        let sv = scrollView!
        return "contentSize=\(sv.contentSize.fmt)  contentOffset=\(sv.contentOffset.fmt)  zoomScale=\(sv.zoomScale.fmt)"
    }

    private func _imageInfo(image: UIImage?) -> String {
        return "image.size=\(image!.size.fmt)"
    }

    private var _frameInfo: String {
        return "sourceImageView.frame=\(sourceImageView.frame.fmt) scrollView.frame=\(scrollView.frame.fmt)"
    }

    private func setUpForScrolling(image: UIImage) {
        sourceImageView.image = image
        sourceImageView.sizeToFit()
        scrollView?.contentSize = (sourceImageView.image?.size)! // sourceImageView.image.size IS NOT AFFECTED BY zoomScale
        scrollView.contentOffset = CGPoint()

        print("   setUpScrolling >", _frameInfo, _scrollInfo)

        updateZoomScales()
        print("   setUpScrolling <", _frameInfo, _scrollInfo)
        //        centerScrollViewContents()
    }

    private func updateZoomScales() {

        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
//        let minScale = min(scaleWidth, scaleHeight) // leaves bands
        let minScale = max(scaleWidth, scaleHeight) // fills the smaller dimension, overflows the larger one
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
    }

    
    fileprivate func saveImageToPhotos(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        let alert = UIAlertController(title: "image saved", message: "image saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // controller startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("===viewDidLoad", _frameInfo)
        scrollView.delegate = self

        sourceImageView.contentMode = .scaleAspectFit
        scrollView.contentMode = .scaleAspectFit

        croppedImageView.contentMode = .scaleAspectFit
        setUpForScrolling(image: UIImage(named: "IMG_2616")!)

        printScales("viewDidLoad")
    }
    
    // helpers
    
    fileprivate func getCroppedImage() -> UIImage {

        let croppedSize = scrollView.bounds.size / scrollView.zoomScale
        let croppedOrigin = scrollView.contentOffset / scrollView.zoomScale * -1.0

        UIGraphicsBeginImageContextWithOptions(croppedSize, true, 0.0)
        
        print("---croppedImage", _scrollInfo, "scrollViewSize=", scrollView.bounds.size.fmt, "croppedSize=", croppedSize.fmt)

        sourceImageView.image?.draw(at: croppedOrigin)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        return croppedImage!
    }
    
    
    func presentImagePicker() {
        printScales("presentImagePicker")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func centerScrollViewContents() {
        sourceImageView.frame.origin.x = max(0, (scrollView.bounds.size.width - sourceImageView.frame.size.width) / 2)
        sourceImageView.frame.origin.y = max(0, (scrollView.bounds.size.height - sourceImageView.frame.size.height) / 2)
    }

    fileprivate func printScales(_ caller: String) {
        print("")
        print("\(caller) printScales imageView.contentMode=\(sourceImageView.contentMode.rawValue)", "scrollView.contentMode=\(scrollView.contentMode.rawValue)")
        print("\(caller) printScales scrollView.zoomScale=\(scrollView.zoomScale) min=\(scrollView.minimumZoomScale) max=\(scrollView.maximumZoomScale)")
        //        print("\(caller) printScales scrollView.contentOffset=\(scrollView.contentOffset) center= \(scrollView.center)")
        print("\(caller) printScales imageView.frame=\(sourceImageView.frame.fmt)")
    }

}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
        
//        print("scrollViewDidZoom", "contentSize=", scrollView.contentSize.fmt,  "contentOffset=", scrollView.contentOffset.fmt, "zoomScale=", scrollView.zoomScale.fmt)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        print("scrollViewDidScroll", "contentSize=", scrollView.contentSize.fmt,  "contentOffset=", scrollView.contentOffset.fmt, "zoomScales= \(scrollView.zoomScale.fmt) ( \(scrollView.minimumZoomScale.fmt)...\(scrollView.maximumZoomScale.fmt) )")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return sourceImageView
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        setUpForScrolling(image: image!)

        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController:  UINavigationControllerDelegate {
    
}

