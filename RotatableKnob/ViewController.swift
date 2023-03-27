//
//  ViewController.swift
//  RotatableKnob
//
//  Created by QSD BIH on 15. 2. 2023..
//

import UIKit
import SnapKit
import Combine

final class ViewController: UIViewController {

    //MARK: - Properties
    private var rotatableKnobView = RotatableKnobView()
    private var levelLabel = UILabel()
    private var levelValueLabel = UILabel()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private final func setUI() {
        addSubviews()
        setConstraints()
        setProperties()
    }
    
    private final func addSubviews() {
        view.addSubview(rotatableKnobView)
        view.addSubview(levelLabel)
        view.addSubview(levelValueLabel)
    }
    
    //MARK: - Setting constraints
    private final func setConstraints() {
        setRotatableKnobViewConstraints()
        setLevelLabelConstraints()
        setLevelValueLabelConstraints()
    }
    
    private final func setRotatableKnobViewConstraints() {
        rotatableKnobView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(75)
        }
    }
    
    private final func setLevelLabelConstraints() {
        levelLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rotatableKnobView.snp.centerX)
            make.top.equalTo(rotatableKnobView.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.width.equalTo(75)
        }
    }
    
    private final func setLevelValueLabelConstraints() {
        levelValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(levelLabel.snp.centerX)
            make.height.equalTo(25)
            make.width.equalTo(75)
            make.top.equalTo(levelLabel.snp.bottom).offset(10)
        }
    }
    
    //MARK: - Setting properties
    private final func setProperties() {
        setRotatableKnobViewProperties()
        setLevelLabelProperties()
        setLevelValueLabelProperties()
        setSuperviewProperties()
    }
    
    private final func setRotatableKnobViewProperties() {
        configureRotatableKnobViewCancellable()
        rotatableKnobView.configure(defaultValue: 0.65)
    }
    
    private final func setLevelLabelProperties() {
        levelLabel.text = "LEVEL"
        levelLabel.font = .systemFont(ofSize: 16, weight: .medium)
        levelLabel.textColor = .white
        levelLabel.backgroundColor = .black
        levelLabel.textAlignment = .center
        levelLabel.adjustsFontSizeToFitWidth = true
    }
    
    private final func setLevelValueLabelProperties() {
        levelValueLabel.text = "0"
        levelValueLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        levelValueLabel.textColor = UIColor(red: 156.0/255.0, green: 214.0/255.0, blue: 251.0/255.0, alpha: 1.0) // you can extract this color to a UIColor extension to make the code nicer :)
        levelValueLabel.textAlignment = .center
        levelValueLabel.backgroundColor = .black
        levelValueLabel.adjustsFontSizeToFitWidth = true
    }
    
    private final func setSuperviewProperties() {
        view.backgroundColor = .white.withAlphaComponent(0.5)
    }

    //MARK: - Cancellable configuration
    private final func configureRotatableKnobViewCancellable() {
        rotatableKnobView.publisher
            .map { $0.asPercentageString }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.text, on: levelValueLabel)
            .store(in: &cancellables)
    }
}
