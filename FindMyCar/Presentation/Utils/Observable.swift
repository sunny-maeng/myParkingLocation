//
//  Observable.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/27.
//

import Foundation

final class Observable<Value> {

    private var listener: ((Value) -> Void)?

    var value: Value {
        didSet {
            listener?(value)
        }
    }

    init(_ value: Value) {
        self.value = value
    }

    func bind(_ closure: @escaping (Value) -> Void) {
        closure(value)
        listener = closure
    }
}
