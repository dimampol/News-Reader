//
//  ImageDownload.swift
//  News Feed Application
//
//  Created by apple on 2017-11-20.
//  Copyright © 2017 Dmitrii Poliakov. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    func downloadImage(from url: String?){
        
        guard let urlString = url else{
            return
        }
        
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil{
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
