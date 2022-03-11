//
//  IconData.swift
//  Clima
//
//  Created by William Daniel da Silva Kuhs on 27/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit

struct IconData: Decodable {
    var id: String?
    var image: Data?
    
    func getIconImage() -> UIImage? {
        if let image = image {
            return UIImage(data: image)
        }
        
        return nil
    }
}
