# OnGestureSwift

<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat" alt="Swift 4 compatible" /></a>
[![Platform](https://img.shields.io/cocoapods/p/PageMenu.svg?style=flat)](https://cocoapods.org/pods/OnGestureSwift)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
(use it and modify it freely, just don't forget to thank me)

This project supplies Swift extensions that will allow developers to use an ```onGesture``` method, such as: ```onClick```, ```onLongPress```, ```onSwipe```, ```onPan``` or **even** ```onDrag``` that wil allow dragging of the view.

It's very similar to the Android SDK's ```setOnClickListener(...)``` method.

#### onClick (a simple tap) usage

```swift
someView.onClick() { (tapGestureRecognizer: UITapGestureRecognizer) in
    // Do something...
}
```

#### onLongPress usage

```swift
mapView.onLongPress({ [weak self] (longPressGestureRecognizer) in
    guard longPressGestureRecognizer.state == .began, let mapView = self?.mapView else { return }

    let longPressedLocationCoordinate = mapView.convert(longPressGestureRecognizer.location(in: mapView), toCoordinateFrom: mapView)
    print("tapped on location's coordinate: \(longPressedLocationCoordinate)")
    // Do stuff with 'longPressedLocationCoordinate'
})

```

#### onSwipe usage

```swift
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
Don't worry about memory leaks, this implementations has been tested and it works perfectly with ARC.
Just be sure you pass [weak self] / [unowned self] in case you don't won't to keep a strong references (you usually would like not to hold a strong reference inside a closure).

Enjoy :)

[Perry](http://linkedin.com/in/perrysh)
