//
//  ViewController.swift
//  iOS_textOnImage_w13
//
//  Created by admin on 16/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    //ImageView outlet, dragged from storyboard
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    
    var imagePicker = UIImagePickerController() //To handle fetching img from iOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self //Assigning object from class to handle image picking return
    }
    
    
    @IBAction func photosBtnPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary //Specifies its gonna be from library
        imagePicker.allowsEditing = true //Allows editting
        present(imagePicker,animated: true,completion: nil)
    }
    
    @IBAction func cameraBtnPressed(_ sender: UIButton) {
        launchCamera() //Call the func to open camera
    }
    
    @IBAction func videoBtnPressed(_ sender: UIButton) {
        imagePicker.mediaTypes = ["public.movie"] //launch video in camera app
        imagePicker.videoQuality = .typeMedium //medium quality
        launchCamera() //launch camera func
    }
    
    
    @IBAction func savePhotoBtnPressed(_ sender: UIButton) { //will just save current image in imageview to photorull, if statement to avoid crash if nothing is in there
        if imageView.image != nil{
            UIImageWriteToSavedPhotosAlbum((imageView.image)!, nil, nil,nil)
        } //TODO could do and else displaying a message or something saying u cant save nothing.
    }
    
    //func to put txt on image
    @IBAction func putTextOnImage(_ sender: UIButton) {
        let txt = textField.text! //get text from field
        //put it in a nsattributedstring and set font, size, colour
        let atrString = NSAttributedString(string: txt, attributes: [.font:UIFont(name: "Avenir Next Demi Bold", size: 100)!, .foregroundColor: UIColor.blue])
        
        let imageSize = imageView.image!.size //get size of image, force unwrapping
        
        let renderer = UIGraphicsImageRenderer(size: imageSize) //create ui image renderer
        
        imageView.image = renderer.image(actions: { (UIGraphicsImageRendererContext) in
            imageView.image!.draw(at: .zero)
            atrString.draw(at: CGPoint(x: 30, y: imageSize.height-150)) //where put it
        })
        
    }
    
    
    
    //What to do when image or video is picked/taken
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //if it´s a video do this
        if let url = info[.mediaURL] as? URL { //True if its a video
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil) //minimal use
            }
        } else { //else its an image then assign the imageview to the editted image
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil) //dismiss the editting screen
        
    }
    
    fileprivate func launchCamera() { //fileprivate cause its used within the same sourcefile.
        //it restricts use of entitity to within the same source file.
        //Camera wont work on simulator cause it doesnt have a camera, but it works on device
        imagePicker.sourceType = .camera
        imagePicker.showsCameraControls = true
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
    }

}

