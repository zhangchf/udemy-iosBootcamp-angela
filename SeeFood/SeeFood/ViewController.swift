//
//  ViewController.swift
//  SeeFood
//
//  Created by Chaofan Zhang on 2018/4/4.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let WATSON_API_KEY = "af76991f0adbe2c130b6e304a2da622a2014b740"
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    var classifiedResults = [String]()
    
    let imagePickerVC = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .photoLibrary
        
        resultImageView.isHidden = true
        shareButton.isHidden = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cameraImageView.image = selectedImage
            
            SVProgressHUD.show()
            cameraButton.isEnabled = false
            identifyImage(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func identifyImage(image: UIImage) {
//        let tempImageUrl = FileManager.default.temporaryDirectory.appendingPathComponent("tempImage.jpeg")
        
        if let compressedImageData = UIImageJPEGRepresentation(image, 0.01),
           let compressedImage = UIImage(data: compressedImageData)
        {
            let version = getCurrentDateString()
            let visualRecognition = VisualRecognition(apiKey: WATSON_API_KEY, version: version)
            print("Do visual recognition， version: \(version)")

            visualRecognition.classify(image: compressedImage, success: { (classifiedImages) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.cameraButton.isEnabled = true
                    self.shareButton.isHidden = false
                }
                if let classResults = classifiedImages.images.first?.classifiers.first?.classes {
                    for classResult in classResults {
                        self.classifiedResults.append(classResult.className)
                    }
                }
                print("classifiedImages:", self.classifiedResults)
                
                DispatchQueue.main.async {
                    self.updateUI(isHotdog: self.classifiedResults.contains("hotdog"))
                }
            })
        } else {
            updateUI(isHotdog: false)
        }
    }
    
    func updateUI(isHotdog: Bool) {
        guard let navigationBar = navigationController?.navigationBar else {
            print("NavigationBar doesn't exist")
            return
        }
        resultImageView.isHidden = false
        if isHotdog {
            navigationItem.title = "Hotdog!"
            navigationBar.barTintColor = UIColor.green
            resultImageView.image = #imageLiteral(resourceName: "hotdog")
        } else {
            navigationItem.title = "Not Hotdog!"
            navigationBar.barTintColor = UIColor.red
            resultImageView.image = #imageLiteral(resourceName: "not-hotdog")
        }
    }
    
    func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }

    @IBAction func onCameraTapped(_ sender: UIBarButtonItem) {
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func onShare(_ sender: UIButton) {
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
    }
}

