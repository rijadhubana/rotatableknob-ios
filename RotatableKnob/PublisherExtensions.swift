//
//  PublisherExtensions.swift
//  RotatableKnob
//
//  Created by QSD BIH on 2. 3. 2023..
//

import Combine

extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        on object: T
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
     
        }
    }

    func weakSink<T: AnyObject>(
        _ weaklyCaptured: T,
        receiveValue: @escaping (T, Self.Output) -> Void
    ) -> AnyCancellable {
        sink { [weak weaklyCaptured] output in
            guard let strongRef = weaklyCaptured else { return }
            receiveValue(strongRef, output)
        }
    }
}
