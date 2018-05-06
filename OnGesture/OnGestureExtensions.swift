//
//  PerrFuncs.swift
//  SomeApp
//
//  Created by Perry on 2/12/16.
//  Copyright © 2016 PerrchicK. All rights reserved.
//

import UIKit
import ObjectiveC

// MARK: - "macros"
public typealias CallbackClosure<T> = ((T) -> Void)
public typealias PredicateClosure<T> = ((T) -> Bool)

// MARK: - Global Methods

/// Inclusively raffles a number from `left` hand operand value to the `right` hand operand value.
///
/// For example: the expression `{ let random: Int =  -3 ~ 5 }` will declare a random number between -3 and 5.
/// - parameter left:   The value represents `from`.
/// - parameter right:  The value represents `to`.
///
/// - returns: A random number between `left` and `right`.
func - (left: CGPoint, right: CGPoint) -> CGPoint { // Reference: http://nshipster.com/swift-operators/
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

extension UIView {

    /**
     Attaches a given closure to the tap event (onClick event)
     
     - parameter onClickClosure: A closure to dispatch when a tap gesture is recognized.
     */
    @discardableResult
    func onClick(_ onClickClosure: @escaping OnTapRecognizedClosure) -> OnClickListener {
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = OnClickListener(target: self, action: #selector(onTapRecognized(_:)), closure: onClickClosure)
        
        tapGestureRecognizer.cancelsTouchesInView = false // Solves bug: https://stackoverflow.com/questions/18159147/iphone-didselectrowatindexpath-only-being-called-after-long-press-on-custom-c
        tapGestureRecognizer.delegate = tapGestureRecognizer
        
        if self is UIButton {
            (self as? UIButton)?.addTarget(self, action: #selector(onTapRecognized(_:)), for: .touchUpInside)
            tapGestureRecognizer.isEnabled = false
        }
        
        addGestureRecognizer(tapGestureRecognizer)
        return tapGestureRecognizer
    }
    
    @objc func onTapRecognized(_ tapGestureRecognizer: UITapGestureRecognizer) {
        var onClickListener: OnClickListener?
        if self is UIButton {
            onClickListener = gestureRecognizers?.filter( { $0.isEnabled == false && $0 is OnClickListener } ).first as? OnClickListener
        } else {
            onClickListener = tapGestureRecognizer as? OnClickListener
        }
        
        guard let _onClickListener = onClickListener else { return }
        
        _onClickListener.closure(_onClickListener)
    }
    
    /**
     Attaches a given closure to the drag gesture event (onDrag event)
     
     - parameter onDragClosure: A closure to dispatch when the drag is recognized.
     - parameter predicateClosure: A closure that determmines whether to call the even or not.
     */
    @discardableResult
    func onDrag(predicateClosure: PredicateClosure<UIView>? = nil, onDragClosure: @escaping CallbackClosure<OnPanListener>) -> OnPanListener {
        return onPan { panGestureRecognizer in
            guard let draggedView = panGestureRecognizer.view, (predicateClosure?(self) ?? true), let onPanListener = panGestureRecognizer as? OnPanListener else { return }
            
            if let pannedPoint = onPanListener.pannedPoint {
                draggedView.center = pannedPoint
            }
            
            onDragClosure(onPanListener)
        }
    }
    
    /**
     Attaches a given closure to the pan gesture event (onPan event)
     
     - parameter onPanClosure: A closure to dispatch when the gesture is recognized.
     */
    @discardableResult
    func onPan(_ onPanClosure: @escaping OnPanRecognizedClosure) -> OnPanListener {
        self.isUserInteractionEnabled = true
        let panGestureRecognizer = OnPanListener(target: self, action: #selector(onPanRecognized(_:)), closure: onPanClosure)
        
        panGestureRecognizer.cancelsTouchesInView = false // Solves bug: https://stackoverflow.com/questions/18159147/iphone-didselectrowatindexpath-only-being-called-after-long-press-on-custom-c
        panGestureRecognizer.delegate = panGestureRecognizer
        addGestureRecognizer(panGestureRecognizer)
        
        return panGestureRecognizer
    }

    @objc func onPanRecognized(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard let onPanListener = panGestureRecognizer as? OnPanListener,
            let draggedView = panGestureRecognizer.view,
            let superview = draggedView.superview else { return }
        
        let locationOfTouch = panGestureRecognizer.location(in: superview)
        
        switch panGestureRecognizer.state {
        case .cancelled: fallthrough
        case .ended:
            onPanListener.startPoint = nil
            onPanListener.pannedPoint = nil
            onPanListener.offsetPoint = nil
            onPanListener.relativeStartPoint = nil
        case .began:
            onPanListener.relativeStartPoint = locationOfTouch
            onPanListener.startPoint = draggedView.center - locationOfTouch
            fallthrough
        default:
            if let startPoint = onPanListener.startPoint {
                onPanListener.pannedPoint = CGPoint(x: locationOfTouch.x + (startPoint.x), y: locationOfTouch.y + (startPoint.y))
                onPanListener.offsetPoint = locationOfTouch - startPoint
            }
            
            if let relativeStartPoint = onPanListener.relativeStartPoint {
                onPanListener.offsetPoint = locationOfTouch - relativeStartPoint
            }
        }
        
        onPanListener.closure(panGestureRecognizer)
    }
    
    /**
     Attaches a given closure to the swipe gesture event (onSwipe event)
     
     - parameter onSwipeClosure: A closure to dispatch when the swipe gesture is recognized.
     - parameter direction: The direction to detect
     */
    @discardableResult
    func onSwipe(direction: UISwipeGestureRecognizerDirection, _ onSwipeClosure: @escaping OnSwipeRecognizedClosure) -> OnSwipeListener {
        self.isUserInteractionEnabled = true
        let swipeGestureRecognizer = OnSwipeListener(target: self, action: #selector(onSwipeRecognized(_:)), closure: onSwipeClosure)
        
        swipeGestureRecognizer.cancelsTouchesInView = false // Solves bug: https://stackoverflow.com/questions/18159147/iphone-didselectrowatindexpath-only-being-called-after-long-press-on-custom-c
        
        swipeGestureRecognizer.delegate = swipeGestureRecognizer
        swipeGestureRecognizer.direction = direction
        
        addGestureRecognizer(swipeGestureRecognizer)
        return swipeGestureRecognizer
    }
    
    @objc func onSwipeRecognized(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        guard let swipeGestureRecognizer = swipeGestureRecognizer as? OnSwipeListener else { return }
        
        swipeGestureRecognizer.closure(swipeGestureRecognizer)
    }
    
    /**
     Attaches a given closure to the long press event (onLongPress event)
     
     - parameter onLongPressClosure: A closure to dispatch when a long press gesture is recognized.
     */
    @discardableResult
    func onLongPress(_ onLongPressClosure: @escaping OnLongPressRecognizedClosure) -> OnLongPressListener {
        self.isUserInteractionEnabled = true
        let longPressGestureRecognizer = OnLongPressListener(target: self, action: #selector(longPressRecognized(_:)), closure: onLongPressClosure)
        
        longPressGestureRecognizer.cancelsTouchesInView = false // Solves bug: https://stackoverflow.com/questions/18159147/iphone-didselectrowatindexpath-only-being-called-after-long-press-on-custom-c
        longPressGestureRecognizer.delegate = longPressGestureRecognizer
        
        addGestureRecognizer(longPressGestureRecognizer)
        return longPressGestureRecognizer
    }
    
    @objc func longPressRecognized(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        guard let longPressGestureRecognizer = longPressGestureRecognizer as? OnLongPressListener else { return }
        
        longPressGestureRecognizer.closure(longPressGestureRecognizer)
    }

}

typealias OnTapRecognizedClosure = (_ tapGestureRecognizer: UITapGestureRecognizer) -> ()
class OnClickListener: UITapGestureRecognizer, UIGestureRecognizerDelegate {
    private(set) var closure: OnTapRecognizedClosure

    init(target: Any?, action: Selector?, closure: @escaping OnTapRecognizedClosure) {
        self.closure = closure
        super.init(target: target, action: action)
    }
    
    @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}

typealias OnLongPressRecognizedClosure = (_ longPressGestureRecognizer: UILongPressGestureRecognizer) -> ()
class OnLongPressListener: UILongPressGestureRecognizer, UIGestureRecognizerDelegate {
    private(set) var closure: OnLongPressRecognizedClosure

    init(target: Any?, action: Selector?, closure: @escaping OnLongPressRecognizedClosure) {
        self.closure = closure
        super.init(target: target, action: action)
    }

    @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

typealias OnPanRecognizedClosure = (_ panGestureRecognizer: UIPanGestureRecognizer) -> ()
class OnPanListener: UIPanGestureRecognizer, UIGestureRecognizerDelegate {
    private(set) var closure: OnPanRecognizedClosure
    var startPoint: CGPoint?
    var relativeStartPoint: CGPoint?
    var offsetPoint: CGPoint?
    var pannedPoint: CGPoint?
    
    init(target: Any?, action: Selector?, closure: @escaping OnPanRecognizedClosure) {
        self.closure = closure
        super.init(target: target, action: action)
    }
    
    @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    //    deinit {
    //        📘("\(className(OnSwipeListener.self)) gone from RAM 💀")
    //    }
}

typealias OnSwipeRecognizedClosure = (_ swipeGestureRecognizer: UISwipeGestureRecognizer) -> ()
class OnSwipeListener: UISwipeGestureRecognizer, UIGestureRecognizerDelegate {
    private(set) var closure: OnSwipeRecognizedClosure
    
    init(target: Any?, action: Selector?, closure: @escaping OnSwipeRecognizedClosure) {
        self.closure = closure
        super.init(target: target, action: action)
    }
    
    @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
