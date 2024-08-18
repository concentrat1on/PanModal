
### PanModal is an elegant and highly customizable presentation API for constructing bottom sheet modals on iOS.

<p align="center">
    <img src="https://github.com/concentrat1on/PanModal/raw/master/Screenshots/panModal.gif" width="30%" height="30%" alt="Screenshot Preview" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Platform-iOS_13+-green.svg" alt="Platform: iOS 13.0+" />
    <a href="https://developer.apple.com/swift" target="_blank"><img src="https://img.shields.io/badge/Language-Swift_5-blueviolet.svg" alt="Language: Swift 5" /></a>
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT" />
</p>

<p align="center">
    <a href="#features">Features</a>
  • <a href="#compatibility">Compatibility</a>
  • <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#documentation">Documentation</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#authors">Authors and Fork editor</a>
  • <a href="#license">License</a>
</p>

## Features

* Supports any type of `UIViewController`
* Seamless transition between modal and content
* Maintains 60 fps performance

## Compatibility

PanModal requires **iOS 13+** with SwiftUI ScrollView interaction in Demo Project.

## Installation

* <a href="https://swift.org/package-manager/" target="_blank">Swift Package Manager</a>:

```swift
dependencies: [
  .package(url: "https://github.com/concentrat1on/PanModal", .exact("1.2.6")),
],
```

## Usage

PanModal was designed to be used effortlessly. Simply call `presentPanModal` in the same way you would expect to present a `UIViewController`

```swift
.presentPanModal(yourViewController)
```

The presented view controller must conform to `PanModalPresentable` to take advantage of the customizable options

```swift
extension YourViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
}
```

### PanScrollable

If the presented view controller has an embedded `UIScrollView` e.g. as is the case with `UITableViewController`, panModal will seamlessly transition pan gestures between the modal and the scroll view

```swift
class TableViewController: UITableViewController, PanModalPresentable {

    var panScrollable: UIScrollView? {
        return tableView
    }
}
```

### Adjusting Heights

Height values of the panModal can be adjusted by overriding `shortFormHeight` or `longFormHeight`

```swift
var shortFormHeight: PanModalHeight {
    return .contentHeight(300)
}

var longFormHeight: PanModalHeight {
    return .maxHeightWithTopInset(40)
}
```

### Updates at Runtime

Values are stored during presentation, so when adjusting at runtime you should call `panModalSetNeedsLayoutUpdate()`

```swift
func viewDidLoad() {
    hasLoaded = true

    panModalSetNeedsLayoutUpdate()
    panModalTransition(to: .shortForm)
}

var shortFormHeight: PanModalHeight {
    if hasLoaded {
        return .contentHeight(200)
    }
    return .maxHeight
}
```

### Sample App

Check out the [Sample App](https://github.com/concentrat1on/PanModal/tree/master/Sample) for more complex configurations of `PanModalPresentable`, including navigation controllers and stacked modals.

## Documentation
Option + click on any of PanModal's methods or notes for detailed documentation.

<p align="left">
    <img src="https://github.com/concentrat1on/PanModal/blob/master/Screenshots/documentation.png" width="50%" height="50%" alt="Screenshot Preview" />
</p>

## Contributing

We will only be fixing critical bugs, thus, for any non-critical issues or feature requests we hope to be able to rely on the community using the library to add what they need. For more information, please read the [contributing guidelines](https://github.com/concentrat1on/PanModal/blob/master/CONTRIBUTING.md).

## Authors and Fork editor

[Stephen Sowole](https://github.com/ste57) • [Tosin Afolabi](https://github.com/tosinaf) • [Illia Topor](https://github.com/concentrat1on) 

## License

<b>PanModal</b> is released under a MIT License. See LICENSE file for details.
