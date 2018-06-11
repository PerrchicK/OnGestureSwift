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

    view.onSwipe(direction: .down) { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
    }
    ...
}
```

### CocoaPods
Simply use: ```pod 'OnGestureSwift'```

## Important Notes
### Memory Management
Don't worry about memory leaks, this implementation has been tested, reviewed, used and improved - **it works perfectly with ARC**, so keep calm and free your mind.
Just make sure you pass [weak self] / [unowned self] in case you don't won't to keep a strong references to ```self``` (you usually would like **not** to hold a strong reference inside a closure).

Enjoy :)

[Perry](http://linkedin.com/in/perrysh)
