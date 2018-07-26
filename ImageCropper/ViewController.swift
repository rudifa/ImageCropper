//
//  ViewController.swift
//  ImageCropper
//
//  Created by Rudolf Farkas on 24.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import UIKit

extension CGPoint {
    var fmt: String { return String(format: "(%.2f, %.2f)", self.x, self.y) }
}

extension CGSize {
    var fmt: String { return String(format: "(%.2f, %.2f)", self.width, self.height) }
}

extension CGFloat {
    var fmt: String { return String(format: "%.3g", self) }
}

class ViewController: UIViewController {

    var imageView = UIImageView()

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var loadImage: UIButton!

    @IBOutlet weak var cropAndSave: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self


        //        imageView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: scrollView.frame.size.width, height: scrollView.frame.size.height)

        imageView.frame = CGRect(origin: CGPoint(), size: scrollView.frame.size)
        imageView.image = UIImage(named: "image-x-generic-icon.png")
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)

        print("   viewDidLoad imageView.contentMode", imageView.contentMode.rawValue)

//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadImage(recognizer:)))
//        tapGestureRecognizer.numberOfTapsRequired = 1
//        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func loadImage(recognizer: UITapGestureRecognizer) {
       presentImagePicker()
    }

    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        self.present(imagePicker, animated: true, completion: nil)
    }

    private func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame

        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        } else {
            contentsFrame.origin.x = 0
        }
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        } else {
            contentsFrame.origin.y = 0
        }
        imageView.frame = contentsFrame
    }

    @IBAction func loadImageTap(_ sender: Any) {
        presentImagePicker()
    }

    fileprivate func setUpImageScroll(_ image: UIImage) {
        imageView.image = image
        imageView.contentMode = .center
        imageView.frame = CGRect(origin: CGPoint(), size: image.size)
        scrollView.contentSize = image.size

        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale

        centerScrollViewContents()
    }

    @IBAction func cropAndSaveTap(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.main.scale)

        print("cropAndSave scrollView.size=\(scrollView.bounds.size) scrollView.offset=\(scrollView.contentOffset) scale=\(UIScreen.main.scale)")

        print("cropAndSave image.size=\(imageView.image?.size) image.scale=\(imageView.image?.scale)")

        let offset = scrollView.contentOffset
        //        let origin = CGPoint(x: -offset.x, y: -offset.y)
        let origin = scrollView.contentOffset

        imageView.image?.draw(at: origin)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        UIImageWriteToSavedPhotosAlbum(result!, nil, nil, nil)

        let alert = UIAlertController(title: "image saved", message: "image saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()

        print("scrollViewDidZoom", "contentSize=", scrollView.contentSize.fmt,  "contentOffset=", scrollView.contentOffset.fmt, "zoomScale=", scrollView.zoomScale)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        print("scrollViewDidScroll", "contentSize=", scrollView.contentSize.fmt,  "contentOffset=", scrollView.contentOffset.fmt, "zoomScale=", scrollView.zoomScale)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("   imagePickerController didFinishPickingMediaWithInfo", "size=\(image.size.fmt)", "scale=\(image.scale.fmt)")

        setUpImageScroll(image)

        picker.dismiss(animated: true, completion: nil)
    }

}

extension ViewController:  UINavigationControllerDelegate {

}

