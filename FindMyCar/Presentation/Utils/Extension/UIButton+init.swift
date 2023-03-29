//
//  MainButton.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/27.
//

import UIKit

extension UIButton {

    convenience init(imageConfig: UIImage.SymbolConfiguration, image: UIImage?) {
        self.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.imageView?.tintColor = .white
        self.backgroundColor = .mainBlue
        self.layer.cornerRadius = Constant.cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
