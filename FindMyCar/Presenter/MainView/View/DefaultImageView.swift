//
//  DefaultImageView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/22.
//

import UIKit

final class DefaultImageView: UIImageView {

    convenience init(imageName: String) {
        let image: UIImage? = UIImage(systemName: imageName)
        self.init(image: image)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
