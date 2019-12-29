//
//  ViewController.swift
//  Fotoroid
//
//  Created by Lucas Santana Brito on 03/11/19.
//  Copyright © 2019 lsb.br. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func selectSource(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Selecionar Fotos", message: "De onde você quer escolher suas fotos ?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { [weak self] (action) in
                self?.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { [weak self] (action) in
            self?.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { [weak self] (action) in
            self?.selectPicture(sourceType: .savedPhotosAlbum)
            
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? EffectsViewController else { return }
        vc.image = sender as? UIImage
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let originalWidth = image.size.width
            let aspectRadio = originalWidth / image.size.height
            var smallSize: CGSize
            
            if aspectRadio > 1 { // landscape
                smallSize = CGSize(width: 1000, height: 1000/aspectRadio)
            
            } else { //portrati
                smallSize = CGSize(width: 1000*aspectRadio, height: 1000)
                
            }
            
            UIGraphicsBeginImageContext(smallSize)
            
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            
            
            UIGraphicsEndImageContext()
            
            dismiss(animated: true) { [weak self] in
                self?.performSegue(withIdentifier: "effectsSegue", sender: smallImage)
            }
        }
    }
}
