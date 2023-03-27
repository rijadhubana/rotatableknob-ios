//
//  FloatExtension.swift
//  RotatableKnob
//
//  Created by QSD BIH on 2. 3. 2023..
//

import UIKit

extension Float {
    var asPercentageString: String {
        return String(Int((self * 100).rounded()))
    }
    
    var normalizedToRotationValue: CGFloat {
        return CGFloat(self * Float(Double.pi * 3/2))
    }
}
