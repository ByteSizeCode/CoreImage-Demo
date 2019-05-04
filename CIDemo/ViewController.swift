//
//  ViewController.swift
//  CoreImage
//
//  Created by Isaac Raval on 5/4/19.
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    //MARK: - Variables
    var intensity = 0.7 //Default
    var filterName = "CITwirlDistortion" //Default
    var context: CIContext! = CIContext()
    var currentFilter: CIFilter!
    let currentImage = UIImage(named: "Beach.jpg")
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func effectIntensitySlider(_ sender: UISlider) {
        //Get value of slider
        let sliderValue = Double(sender.value)
        //Change image intensity
        intensity = (sliderValue * 5) + 0.1
        //Update image effect
        DispatchQueue.main.async {
            self.applyProcessing(currentFilter: self.currentFilter, context: self.context, currentImage: self.currentImage!)
        }
    }
    
    @IBAction func bumpDistortion(_ sender: UIButton) {
        print("Pressed")
        updateImageEffect(name: "CIBumpDistortion")
    }
    
    @IBAction func twirlDistortion(_ sender: UIButton) {
        updateImageEffect(name: "CITwirlDistortion")
    }
    
    
    @IBAction func sepia(_ sender: UIButton) {
        updateImageEffect(name: "CISepiaTone")
    }
    
    @IBAction func pixellate(_ sender: UIButton) {
        updateImageEffect(name: "CIPixellate")
    }
    
    @IBAction func unsharpMask(_ sender: UIButton) {
        updateImageEffect(name: "CIUnsharpMask")
    }
    
    @IBAction func vignette(_ sender: UIButton) {
        updateImageEffect(name: "CIVignette")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make sure we have a valid image before continuing
        guard currentImage != nil else { return }

        //Prepare image and fetch effect
        setUp()
        
        //Apply processing
        applyProcessing(currentFilter: currentFilter, context: context, currentImage: currentImage!)
        
//        imageView.image = UIImage(named: "Beach.jpg")
    }
}

extension ViewController {
    func setUp() {
        //Fetch effect
        currentFilter = CIFilter(name: filterName)
        
        let beginImage = CIImage(image: currentImage!)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    }
    
    func applyProcessing(currentFilter: CIFilter, context:CIContext, currentImage: UIImage) {
        //Apply processing
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
    func updateImageEffect(name: String) {
        //Change image effect
        filterName = name
        //Update image effect
        DispatchQueue.main.async {
            self.setUp()
            self.applyProcessing(currentFilter: self.currentFilter, context: self.context, currentImage: self.currentImage!)
            self.imageView.setNeedsDisplay() //Update ImageView
        }
    }
}
