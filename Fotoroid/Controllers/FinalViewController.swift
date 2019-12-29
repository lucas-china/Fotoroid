//
//  FinalViewController.swift
//  Fotoroid
//
//  Created by Lucas Santana Brito on 03/11/19.
//  Copyright © 2019 lsb.br. All rights reserved.
//

import UIKit
import Photos

class FinalViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhoto()
    }
    
    private func setupPhoto() {
        photoImageView.image = image
        photoImageView.layer.borderWidth = 10
        photoImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func save(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            switch status {
                case .authorized:
                    self?.saveToAlbum()
                default:
                    self?.showAlert(title: "Error", message: "Você precisa autorizar o acesso ao álbum de fotos para poder salvar sua foto.")
            }
            
        }
    }
    
    private func saveToAlbum() {
        PHPhotoLibrary.shared().performChanges({
            let createRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
            let addAssetsRequest = PHAssetCollectionChangeRequest()
            addAssetsRequest.addAssets([createRequest.placeholderForCreatedAsset] as NSArray)
            
        }) { (success, error) in
            if success {
                
                DispatchQueue.main.async {
                    self.showAlert(title: "Imagem salva!!", message: "Sua imagem foi salva no álbum de fotos")
                }
                
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(OKAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func restart(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

}
