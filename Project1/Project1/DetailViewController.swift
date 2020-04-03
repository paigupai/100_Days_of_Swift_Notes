//
//  DetailViewController.swift
//  Project1
//
//  Created by paigu on 2020/04/04.
//  Copyright © 2020 paigu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var selectImage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         title = selectImage
        //不放大
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToload = selectImage {
            imageView.image = UIImage(named: imageToload)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
