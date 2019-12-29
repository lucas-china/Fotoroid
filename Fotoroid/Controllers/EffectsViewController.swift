//
//  EffectsViewController.swift
//  Fotoroid
//
//  Created by Lucas Santana Brito on 03/11/19.
//  Copyright © 2019 lsb.br. All rights reserved.
//

import UIKit

class EffectsViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var image: UIImage!
    lazy var filterManager: FilterManager = {
        let filterManager = FilterManager(image: image)
        return filterManager
    }()
    
    let filterImageName = [
        "comic",
        "sepia",
        "halftone",
        "crystallize",
        "vignette",
        "noir"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func showLoading(_ show: Bool) {
        loadingView.isHidden = !show
    }
}

extension EffectsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterManager.filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EffectCollectionViewCell
            else { return EffectCollectionViewCell() }
        
        cell.effectImageView.image = UIImage(named: filterImageName[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let type = FilterType(rawValue: indexPath.row) {
            showLoading(true)
            DispatchQueue.global(qos: .userInitiated).async {
                let filterImage = self.filterManager.applyFilter(type: type)
                DispatchQueue.main.sync {
                    self.photoImageView.image = filterImage
                    self.showLoading(false)
                }
            }
            
        }
    }
    
    
}
