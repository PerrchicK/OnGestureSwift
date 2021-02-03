# OnGestureSwift

<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat" alt="Swift 4 compatible" /></a>
[![Platform](https://img.shields.io/cocoapods/p/PageMenu.svg?style=flat)](https://cocoapods.org/pods/OnGestureSwift)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
(use it and modify it freely, just don't forget to thank me)

The Android SDK allows developers take any ```View``` object and set an ```OnClickListener``` object to it, now you can also do it in Swift!
Take any ```UIView``` object and set a "listener" with an action inside a closure by using this CocoaPod project.

This project supplies lightweight Swift extensions that let developers use an ```onGesture``` method, such as: ```onClick```, ```onLongPress```, ```onSwipe```, ```onPan``` (and **even** ```onDrag``` that will allow dragging the view).

It's very similar to the Android SDK's ```setOnClickListener(...)``` method.

#### onClick (a simple tap) usage

```swift
import OnGestureSwift

...

someView.onClick() { (tapGestureRecognizer: UITapGestureRecognizer) in
    // Do something...
}
```

#### onLongPress usage

```swift
import OnGestureSwift

...

mapView.onLongPress({ [weak self] (longPressGestureRecognizer) in
    guard longPressGestureRecognizer.state == .began, let mapView = self?.mapView else { return }

    let longPressedLocationCoordinate = mapView.convert(longPressGestureRecognizer.location(in: mapView), toCoordinateFrom: mapView)
    print("tapped on location's coordinate: \(longPressedLocationCoordinate)")
    // Do stuff with 'longPressedLocationCoordinate'
})

```

#### onSwipe usage

```swift
import OnGestureSwift

...

override func viewDidLoad() {
    super.viewDidLoad()

    view.onSwipe(direction: .down) { [unowned self] _ in
        self.dismiss(animated: true, completion: nil)
    }
    ...
}
```

#### onPan usage

```swift
import OnGestureSwift

...

someButton.onPan { [weak self] (panGestureRecognizer) in
    guard let strongSelf = self else { return }

    if let superview = panGestureRecognizer.view?.superview {
        let locationOfPan = panGestureRecognizer.location(in: superview)
        // Do something with 'locationOfPan'
    }
}
```

#### onDrag usage

```swift
import OnGestureSwift

...

someLabel.onDrag(predicateClosure: { _ in
    return true
}, onDragClosure: { dragGestureListener in
    guard let draggingPoint = dragGestureListener.pannedPoint else { return }

    // Do something with 'draggingPoint'
})
```

### CocoaPods
[![](https://img.shields.io/cocoapods/v/OnGestureSwift.svg?style=flat)](https://cocoapods.org/pods/OnGestureSwift)

To install [this pod](https://cocoapods.org/pods/OnGestureSwift) simply add `pod 'OnGestureSwift'` to your Podfile like this example:
```
target 'MyApp' do
  pod 'OnGestureSwift'
end
```
Then run a `pod install` inside your terminal, or from CocoaPods.app.



## Important Notes
### Memory Management
Don't worry about memory leaks, this implementation has been tested, reviewed, used and improved - **it works perfectly with ARC**. I did try using `objc_setAssociatedObject` in the past but I saw it caused memory leaks so it's not recommended. The selected solution has no memory issues, so keep calm and free your mind. :)

Just make sure you use `[weak self]` / `[unowned self]` because **you don't want** to keep a strong references to ```self``` (basically, usually we would like **not** to hold strong references to ```self``` inside closures).

Enjoy :)

[Perry](http://linkedin.com/in/perrysh)
