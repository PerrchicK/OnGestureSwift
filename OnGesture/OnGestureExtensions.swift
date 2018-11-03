//
//  PerrFuncs.swift
//  SomeApp
//
//  Created by Perry on 2/12/16.
//  Copyright © 2016 PerrchicK. All rights reserved.
//

import UIKit
import ObjectiveC

// MARK: - Global Methods

public func - (left: CGPoint, right: CGPoint) -> CGPoint { // Reference: http://nshipster.com/swift-operators/
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

extension UIView {

    /**
     Attaches a given closure to the tap event (onClick event)
     
     - parameter onClickClosure: A closure to dispatch when a tap gesture is recognized.
     */
    @discardableResult
    public func onClick(_ onClickClosure: @escaping OnGesture.OnTapRecognizedClosure) -> OnGesture.OnClickListener {
        self.isUserInteractionEnabled = true
        let onClickListener = OnGesture.OnClickListener(target: self, action: #selector(onTapRecognized(_:)), closure: onClickClosure)
        
        onClickListener.cancelsTouchesInView = false // Solves bug: https://stackoverflow.com/questions/18159147/iphone-didselectrowatindexpath-only-being-called-after-long-press-on-custom-c
        onClickListener.delegate = onClickListener
        
        if self is UIButton {
            (self as? UIButton)?.addTarget(self, action: #selector(onTapRecognized(_:)), for: .touchUpInside)
            onClickListener.isEnabled = false
        }
        
        addGestureRecognizer(onClickListener)
        return onClickListener
    }
    
    @objc func onTapRecognized(_ tapGestureRecognizer: UITapGestureRecognizer) {
        var _onClickListener: OnGesture.OnClickListener?
        if self is UIButton {
            _onClickListener = gestureRecognizers?.filter( { $0.isEnabled == false && $0 is OnGesture.OnClickListener } ).first as? OnGesture.OnClickListener
        } else {
            _onClickListener = tapGestureRecognizer as? OnGesture.OnClickListener
        }
        
        guard let onClickListener = _onClickListener else { return }
        
        onClickListener.closure(onClickListener)
    }
    
    /**
     Attaches a given closure to the drag gesture event (onDrag event)
     
     - parameter onDragClosure: A closure to dispatch when the drag is recognized.
     - parameter predicateClosure: A closure that determmines whether to call the even or not.
     */
    @discardableResult
    public func onDrag(predicateClosure: OnGesture.PredicateClosure<UIView>? = nil, onDragClosure: @escaping OnGesture.CallbackClosure<OnGesture.OnPanListener>) -> OnGesture.OnPanListener {
        return onPan { panGestureRecognizer in
            guard let draggedView = panGestureRecognizer.view, (predicateClosure?(self) ?? true), let onPanListener = panGestureRecognizer as? OnGesture.OnPanListener else { return }
            
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
    public func onPan(_ onPanClosure: @escaping OnGesture.OnPanRecognizedClosure) -> OnGesture.OnPanListener {
        self.isUserInteractionEnabled = true
        let onPanListener = OnGesture.OnPanListener(target: self, action: #selector(onPanRecognized(_:)), closure: onPanClosure)
        
        onPanListener.cancelsTouchesInView = false // Solves bug: https://stackoverflow.com/questions/18159147/iphone-didselectrowatindexpath-only-being-called-after-long-press-on-custom-c
        onPanListener.delegate = onPanListener
        addGestureRecognizer(onPanListener)
        
        return onPanListener
    }

    @objc func onPanRecognized(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard let onPanListener = panGestureRecognizer as? OnGesture.OnPanListener,
            let draggedView = panGestureRecognizer.view,
            let superview = draggedView.superview else { return }
        
        let locationOfTouch = panGestureRecognizer.location(in: superview)
        
        switch panGestureRecognizer.state {
        case .cancelled: fallthrough
        case .ended:
            onPanListener.startPoint = nil
            onPanListener._pannedPoint = nil
            onPanListener.offsetPoint = nil
            onPanListener.relativeStartPoint = nil
        case .began:
            onPanListener.relativeStartPoint = locationOfTouch
            onPanListener.startPoint = draggedView.center - locationOfTouch
            fallthrough
        default:
            if let startPoint = onPanListener.startPoint {
                onPanListener._pannedPoint = CGPoint(x: locationOfTouch.x + (startPoint.x), y: locationOfTouch.y + (startPoint.y))
                onPanListener.offsetPoint = locationOfTouch - startPoint
            }
            
            if let relativeStartPoint = onPanListener.relativeStartPoint {
                onPanListener.offsetPoint = locationOfTouch - relativeStartPoint
            }
        }
        
        onPanListener.closure(onPanListener)
    }
    
    /**
     Attaches a given closure to the swipe gesture event (onSwipe event)
     
     - parameter onSwipeClosure: A closure to dispatch when the swipe gesture is recognized.
     - parameter direction: The direction to detect
     */
    @discardableResult
    public func onSwipe(direction: UISwipeGestureRecognizerDirection, _ onSwipeClosure: @escaping OnGesture.OnSwipeRecognizedClosure) -> OnGesture.OnSwipeListener {
        self.isUserInteractionEnabled = true
        let swipeGestureRecognizer = OnGesture.OnSwipeListener(target: self, action: #selector(onSwipeRecognized(_:)), closure: onSwipeClosure)
        
        swipeGestureRecognizer.cancelsTouchesInView = false // Solves bug: https://stackoverflow.com/questions/18159147/iphone-didselectrowatindexpath-only-being-called-after-long-press-on-custom-c
        
        swipeGestureRecognizer.delegate = swipeGestureRecognizer
        swipeGestureRecognizer.direction = direction
        
        addGestureRecognizer(swipeGestureRecognizer)
        return swipeGestureRecognizer
    }
    
    @objc func onSwipeRecognized(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        guard let onSwipeListener = swipeGestureRecognizer as? OnGesture.OnSwipeListener else { return }
        
        onSwipeListener.closure(onSwipeListener)
    }
    
    /**
     Attaches a given closure to the long press event (onLongPress event)
     
     - parameter onLongPressClosure: A closure to dispatch when a long press gesture is recognized.
     */
    @discardableResult
    public func onLongPress(_ onLongPressClosure: @escaping OnGesture.OnLongPressRecognizedClosure) -> OnGesture.OnLongPressListener {
        self.isUserInteractionEnabled = true
        let longPressGestureRecognizer = OnGesture.OnLongPressListener(target: self, action: #selector(longPressRecognized(_:)), closure: onLongPressClosure)
        
        longPressGestureRecognizer.cancelsTouchesInView = false // Solves bug: https://stackoverflow.com/questions/18159147/iphone-didselectrowatindexpath-only-being-called-after-long-press-on-custom-c
        longPressGestureRecognizer.delegate = longPressGestureRecognizer
        
        addGestureRecognizer(longPressGestureRecognizer)
        return longPressGestureRecognizer
    }
    
    @objc func longPressRecognized(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        guard let onLongPressListener = longPressGestureRecognizer as? OnGesture.OnLongPressListener else { return }
        
        onLongPressListener.closure(onLongPressListener)
    }

}
