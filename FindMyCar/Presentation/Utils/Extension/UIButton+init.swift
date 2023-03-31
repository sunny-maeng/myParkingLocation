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
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        setBackgroundColor(.systemGray3, for: .disabled)
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        setBackgroundImage(backgroundImage, for: state)
    }
}
