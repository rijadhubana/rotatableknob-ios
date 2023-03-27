//
//  CGAffineTransformExtension.swift
//  RotatableKnob
//
//  Created by QSD BIH on 2. 3. 2023..
//

import UIKit

extension CGAffineTransform {
    var rotationAngle: Float { //gets the rotation angle via the pi value of rotation
        return atan2f(Float(self.b), Float(self.a)) * (180 / Float(Double.pi))
    }
    
    var normalizedValueViaRotation: Float { //gets the 0-100 value via current rotation
        var piValue = rotationAngle * .pi / 180
        if piValue < 0 { //for cases between 180 - 270 degrees
            piValue = .pi + abs((abs(piValue) - .pi))
        }
        if piValue > 6 { //edge case, clamp to 0 if the rotation degrees drop to 330-360 range
            piValue = 0
        }
        else if piValue > 4.737 { //clamp to pi * 3/2 if it reaches the upper point
            piValue = 4.737
        }
        return piValue / Float(Double.pi * 3/2)
    }
    

}
