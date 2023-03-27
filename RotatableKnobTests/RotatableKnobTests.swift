//
//  RotatableKnobTests.swift
//  RotatableKnobTests
//
//  Created by QSD BIH on 2. 3. 2023..
//

import XCTest

@testable import RotatableKnob

class RotatableKnobTests: XCTestCase {

    func testPercentageConversion() throws {
        for i in 0...100 {
            let divided = Float(i) / 100
            var transform = CGAffineTransform.identity
            transform = transform.rotated(by: divided.normalizedToRotationValue)
            XCTAssertEqual(String(i), transform.normalizedValueViaRotation.asPercentageString)
        }
    }

}
