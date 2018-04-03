//
//  ViewController.swift
//  WhatsIt
//
//  Created by Chaofan Zhang on 2018/4/3.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    let imagePickerVC = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("UserPickedImage is null")
            return
        }
        detect(image: userPickedImage)
    }
    
    func detect(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            print("UserPickedImage can't create a CIImage")
            return
        }
        
        capturedImageView.image = image
        dismiss(animated: true, completion: nil)
        
        if let model = try? VNCoreMLModel(for: Inceptionv3().model) {
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let error = error {
                    print("ML request failed \(error)")
                }
                if let results = request.results as? [VNClassificationObservation], let firstResult = results.first {
                    print(firstResult.identifier, firstResult.confidence.binade)
                    self.displayResult(identifier: firstResult.identifier, confidence: firstResult.confidence.binade)
                }
            }
            
            let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            do {
                try imageRequestHandler.perform([request])
            } catch {
                print("Image Request failed \(error)")
            }
        }
    }
    
    func displayResult(identifier: String, confidence: Float) {
        resultLabel.text = "\(identifier)\n\n\n(confidence: \(confidence))" //Auto-sizing label height, with height constraint set to >= 64.
        
//        resultLabel.alpha = 0.0
//        UIView.animate(withDuration: 0.2, animations: {
//            self.resultLabel.alpha = 1
//        }) { (finished) in
//            UIView.animate(withDuration: 0.2, delay: 5, animations: {
//                self.resultLabel.alpha = 0
//            }, completion: nil)
//        }
    }
    
    
    @IBAction func onCameraTapped(_ sender: UIBarButtonItem) {
        present(imagePickerVC, animated: true, completion: nil)
    }
    
}

