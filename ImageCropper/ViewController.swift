//
//  ViewController.swift
//  ImageCropper
//
//  Created by Rudolf Farkas on 24.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageView = UIImageView()

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var cropAndSave: UIButton!

    @IBAction func cropAndSaveTap(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
//        imageView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        imageView.frame = CGRect(origin: CGPoint(), size: scrollView.frame.size)
        imageView.image = UIImage(named: "image-x-generic-icon.png")
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadImage(recognizer:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func loadImage(recognizer: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
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

    }

    func centerScrollViewContent() {
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

}

