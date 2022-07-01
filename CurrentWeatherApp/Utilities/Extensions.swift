//
//  Extensions.swift
//  CurrentWeatherApp
//
//  Created by Ivan Ramirez on 2/3/22.
//

import UIKit

extension UIView {

    /**
     An extension on UIView that renders a gradient on a UIViewController

     - Parameter topColor: Top color for gradient
     - Parameter bottomColor: Bottom color for gradient
     */
    func verticalGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor,
            #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor,
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
            #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor,
            #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor

        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.8)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.2)

        self.layer.insertSublayer(gradient, at: 0)
    }

}
