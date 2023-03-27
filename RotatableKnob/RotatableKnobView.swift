//
//  RotatableKnobView.swift
//  RotatableKnob
//
//  Created by QSD BIH on 15. 2. 2023..
//

import UIKit
import SnapKit
import Combine

final class RotatableKnobView: UIView {
    
    //MARK: - Properties
    private var knobImage = UIImageView()
    private var clearOverlayView = UIView()
    
    private var defaultKnobValue = Float(0.5)
    private var previousTranslationValue = CGFloat(0)
    private var currentTranslationValue = CGFloat(0)
    @ClampedKnobTransform private var currentRotation = CGAffineTransform.identity {
        didSet {
            valueChangeSubject.send(currentRotation.normalizedValueViaRotation)
        }
    }
    
    private var valueChangeSubject = PassthroughSubject<Float, Never>()
    
    var publisher: AnyPublisher<Float, Never> {
        return valueChangeSubject.eraseToAnyPublisher()
    }
    
    final func changeKnobTransformation(rotationValue: Float) {
        currentRotation = .identity.rotated(by: rotationValue.normalizedToRotationValue)
        UIView.animate(withDuration: 0.15) {
            self.knobImage.transform = self.currentRotation
        }
    }
    
    final func configure(defaultValue: Float = 0.5) {
        defaultKnobValue = defaultValue
        addSubviews()
        setConstraints()
        setProperties()
        changeKnobTransformation(rotationValue: defaultValue)
    }
    
    private final func addSubviews() {
        addSubview(knobImage)
        addSubview(clearOverlayView)
    }
    
    //MARK: - Setting constraints
    private final func setConstraints() {
        setKnobImageConstraints()
        setClearOverlayConstraints()
    }
    
    private final func setKnobImageConstraints() {
        knobImage.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private final func setClearOverlayConstraints() {
        clearOverlayView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Setting properties
    private final func setProperties() {
        setKnobImageProperties()
        setClearOverlayProperties()
    }
    
    private final func setKnobImageProperties() {
        knobImage.image = UIImage(named: "knob")
        knobImage.contentMode = .scaleAspectFit
        knobImage.transform = currentRotation
    }
    
    private final func setClearOverlayProperties() {
        clearOverlayView.isUserInteractionEnabled = true
        clearOverlayView.backgroundColor = .clear
        clearOverlayView.addGestureRecognizer(panGesture)
        clearOverlayView.addGestureRecognizer(doubleTapGesture)
    }
    
    //MARK: - Core functionality
    @objc private final func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        // if the gesture ends, set the previous translation value to 0
        // and exit the function
        if gesture.state == .ended {
            previousTranslationValue = 0
            return
        }

        // we are using next 2 lines of code to determine the direction and the speed of the pan gesture
        currentTranslationValue = gesture.translation(in: self).x
        let valueChange = currentTranslationValue - previousTranslationValue
        if valueChange < 0 { //user is dragging to the left, so we need to rotate the knob in the counterclokwise direction
            currentRotation = currentRotation.rotated(by: -getTransformationChangeByValue(valueChange))
            knobImage.transform = currentRotation
        }
        else { //user is dragging to the right, rotate clockwise
            currentRotation = currentRotation.rotated(by: getTransformationChangeByValue(valueChange))
            knobImage.transform = currentRotation
        }
        previousTranslationValue = currentTranslationValue
    }
    
    @objc private final func doubleTapAction() {
        changeKnobTransformation(rotationValue: defaultKnobValue)
    }
    
    //this function is used to determine the speed of the pan gesture, and returns
    //a value for the rotation accordingly
    //notice that it always returns a positive value, so in order to rotate counterclockwise
    //a minus sign needs to be added before calling the function
    private final func getTransformationChangeByValue(_ value: CGFloat) -> CGFloat {
        if abs(value) < 1.5 {
            return 0.025
        }
        else if abs(value) >= 1.5 && abs(value) < 3 {
            return 0.05
        }
        else if abs(value) >= 3 && abs(value) <= 5 {
            return 0.1
        }
        else {
            return 0.2
        }
    }
    
    //MARK: - Computed vars
    private var panGesture: UIPanGestureRecognizer {
        return UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
    }
    
    private var doubleTapGesture: UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        gesture.numberOfTapsRequired = 2
        return gesture
    }
}
