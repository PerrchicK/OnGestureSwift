//
//  OnGestureClasses.swift
//  OnGesture
//
//  Created by Perry Shalev on 03/11/2018.
//  Copyright © 2018 Perry Sh. All rights reserved.
//

import Foundation

public class OnGesture {
    public typealias CallbackClosure<T> = ((T) -> Void)
    public typealias PredicateClosure<T> = ((T) -> Bool)

    public typealias OnTapRecognizedClosure = (_ tapGestureRecognizer: OnClickListener) -> ()
    public class OnClickListener: UITapGestureRecognizer, UIGestureRecognizerDelegate {
        private(set) var closure: OnTapRecognizedClosure
        public var userInfo: Any?

        init(target: Any?, action: Selector?, closure: @escaping OnTapRecognizedClosure) {
            self.closure = closure
            super.init(target: target, action: action)
        }
        
        @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }

        func removeSelf() {
            if let mySelf = view?.gestureRecognizers?.filter( { $0 == self } ).first {
                view?.removeGestureRecognizer(mySelf)
            }
        }
    }
    
    public typealias OnLongPressRecognizedClosure = (_ longPressGestureRecognizer: OnLongPressListener) -> ()
    public class OnLongPressListener: UILongPressGestureRecognizer, UIGestureRecognizerDelegate {
        private(set) var closure: OnLongPressRecognizedClosure
        public var userInfo: Any?

        init(target: Any?, action: Selector?, closure: @escaping OnLongPressRecognizedClosure) {
            self.closure = closure
            super.init(target: target, action: action)
        }
        
        @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }

        func removeSelf() {
            if let mySelf = view?.gestureRecognizers?.filter( { $0 == self } ).first {
                view?.removeGestureRecognizer(mySelf)
            }
        }
    }
    
    public typealias OnPanRecognizedClosure = (_ panGestureRecognizer: OnPanListener) -> ()
    public class OnPanListener: UIPanGestureRecognizer, UIGestureRecognizerDelegate {
        private(set) var closure: OnPanRecognizedClosure
        var startPoint: CGPoint?
        var relativeStartPoint: CGPoint?
        var offsetPoint: CGPoint?
        internal var _pannedPoint: CGPoint?
        public var userInfo: Any?
        public var pannedPoint: CGPoint? {
            return _pannedPoint
        }

        init(target: Any?, action: Selector?, closure: @escaping OnPanRecognizedClosure) {
            self.closure = closure
            super.init(target: target, action: action)
        }
        
        @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }
        
        func removeSelf() {
            if let mySelf = view?.gestureRecognizers?.filter( { $0 == self } ).first {
                view?.removeGestureRecognizer(mySelf)
            }
        }
    }
    
    public typealias OnSwipeRecognizedClosure = (_ swipeGestureRecognizer: OnSwipeListener) -> ()
    public class OnSwipeListener: UISwipeGestureRecognizer, UIGestureRecognizerDelegate {
        private(set) var closure: OnSwipeRecognizedClosure
        public var userInfo: Any?

        init(target: Any?, action: Selector?, closure: @escaping OnSwipeRecognizedClosure) {
            self.closure = closure
            super.init(target: target, action: action)
        }
        
        @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }
        
        func removeSelf() {
            if let mySelf = view?.gestureRecognizers?.filter( { $0 == self } ).first {
                view?.removeGestureRecognizer(mySelf)
            }
        }
    }
}
