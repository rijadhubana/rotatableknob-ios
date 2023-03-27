//
//  ClampedKnobTransform.swift
//  RotatableKnob
//
//  Created by QSD BIH on 15. 2. 2023..
//

import UIKit

@propertyWrapper
struct ClampedKnobTransform {
    var wrappedValue: CGAffineTransform {
        didSet {
            if wrappedValue.rotationAngle >= -90
                && wrappedValue.rotationAngle <= -70 {
                //if the value is in range of -90 to -70 degrees,
                //that means that in our rotation case
                //the rotation is in the 270 to 300 degrees range,
                //and needs to be clamped down to
                //270 degrees (which is pi * 3/2)
                wrappedValue = .identity.rotated(by: Double.pi*3/2)
            }
            else if wrappedValue.rotationAngle < 0
                    && abs(wrappedValue.rotationAngle) < 30 {
                //if the value is less than 0
                //and its absolute value is less than 30
                //that means that it is in range
                //of 0 to -30 degrees (or 330 - 360 degrees)
                //and it needs to be clamped up
                //to 0 degrees (which is the .identity)
                wrappedValue = .identity
            }
        }
    }

    init(wrappedValue: CGAffineTransform) {
        self.wrappedValue = wrappedValue
    }
}
