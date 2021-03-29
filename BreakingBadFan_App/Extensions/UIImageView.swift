//
//  UIImageView.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 26/02/2021.
//

import UIKit

extension UIImageView {
    
    func loadImageFromUrl(urlString: String?) {
        guard
            let urlString = urlString,
            let url = URL(string: urlString)
        else {
            print("URL unavailable")
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
