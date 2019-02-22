#Ordnance Survey Swift Code Style Guidelines

---

The aim of this document is to promote idiomatic usage of the Swift language, to assist readability by providing a consistent style, and to make potential defects and problems easier to spot.

## Code Formatting

* Spaces, not tabs; 4 spaces per indent; braces inline with the preceding statement. We currently have no formatting tools in place, so where possible use Xcode's indentation tools.

* Types in upper camel case. e.g. `MapView`

* Variables and constants in lower camel case, e.g. `routeRecordingController`

* Use swift modules to namespace the code, as opposed to Objective-C style class prefixes.

* enums should be uppercase, e.g.

```
enum Direction {
    case North, South, East, West
}
```
* Avoid unnecessary abbreviation - `viewController` is easier to read than `vc`

## Best Practices

* Use type inference wherever possible, to reduce redundant type declarations, e.g.

`let viewController = UIViewController()` rather than:

`let viewController: UIViewController = UIViewController()`

* Let the compiler infer `self` whenever possible. Exceptions are setting in `init()` and non-escaping closures, e.g.:

```
struct GridPoint {
    let easting: Double
    let northing: Double

    init(easting: Double, northing: Double) {
        self.easting = easting
        self.northing = northing
    }
}
```
* Closure syntax. Use capture list type inference and trailing closures whenever possible to avoid overly verbose code. e.g.

```
session.dataTaskWithRequest(urlRequest) { (data, response, error) in
  // Handle response
}
```
rather than

```
session.dataTaskWithRequest(urlRequest, completionHandler: { (data: NSData?, response: NSResponse?, error: NSError?) -> Void in
  // Handle response
})
```

* Prefer to capture `self` as `unowned` over `weak` wherever possible. `unowned` is likely to be enough to safely break most retain cycles without needing to resort to optional chaining of `self` or to create a new `strongSelf` variable. `unowned` is [faster](https://twitter.com/jckarter/status/654819932962598913). This doesn't mean there aren't times when `weak` is the correct option, so ensure you understand the [difference](http://krakendev.io/blog/weak-and-unowned-references-in-swift). For any short lived closure, for example an animation block, the chances are you don't need any specific capture semantics at all.

* Use `let` over `var` whenever possible. Consider if your things really need to be mutable.

* Favour value types wherever it makes sense, most likely in model objects, but particularly anywhere that doesn't require identity. There is lots of documentation and arguments on the internet, but for the time being, if unsure, follow [Apple's Guidelines](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-ID92)

* Use `guard` and `if let` judiciously. Particularly favour returning early where appropriate.

```
  guard let activityIndicator = activityIndicator else {
     return
  }
  let leading = NSLayoutConstraint(item: activityIndicator, attribute:.Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
  let trailing = NSLayoutConstraint(item: activityIndicator, attribute:.Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
  let top = NSLayoutConstraint(item: activityIndicator, attribute:.Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
  let bottom = NSLayoutConstraint(item: activityIndicator, attribute:.Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
  addConstraints([leading, trailing, top, bottom])
```
over

```
  if let activityIndicator = activityIndicator {
    let leading = NSLayoutConstraint(item: activityIndicator, attribute:.Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
    let trailing = NSLayoutConstraint(item: activityIndicator, attribute:.Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
    let top = NSLayoutConstraint(item: activityIndicator, attribute:.Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
    let bottom = NSLayoutConstraint(item: activityIndicator, attribute:.Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    addConstraints([leading, trailing, top, bottom])
  }
```
For brevity, if referencing something briefly, however, optional chaining is fine:

```
  activityIndicator?.startAnimating()
```

* `as!` should be considered an error. Use `guard` or `if let` with `as?` and handle the cast failure.

* Constants should be avoided at global level, and instead declared static within the relevant type they correspond to. This allows them to be referenced without an instance of the type, as well as from Objective-C if required, e.g.

```
struct NationalGrid {
    static let nationalGridWidth = 700000
    static let nationaGridHeight = 1300000
}
```

* Computed Properties - Use the short version (i.e. omit the `get {...}` block) if you only need a getter:

```
class RandomGenerator {
    var randomNumber: UInt32 {
        return arc4random()
    }
}
```

* Singletons - If you think you need to use a singleton, think long and hard. Usually, the problem can be solved in a more elegant way. That said, if you really need one, a singleton in Swift is simple to implement and thread safe by default (unlike Objective-C):

```
class DownloadService {
    static let sharedInstance = DownloadService()
}
```

## Access Control

* Mark items as `private` to denote implementation detail. If you find yourself marking a property or method as `internal` or `public` purely to test it, you need to redesign your API. Only a type's public API should be visible outside of the file.

## Error Handling

* Use `guard` to fail or return fast in a method over the more verbose `if let`, e.g:

```
guard let viewController = requiredViewController? else {
    print("Warning: cannot do this without a view controller.")
    return
}
doSomething(viewController)
```
over:

```
if let viewController = requiredViewController? {
    doSomething(viewController)
} else {
    print("Warning: cannot do this without a view controller.")
    return
}

```

* Use `do/try/catch` for anything that will be called synchronously and may throw an error.

* Avoid `try!`. Instead, wrap in `do {...} catch {...}` to provide context.

* For asynchronous APIs, considering using a `Result` type to return values:

```
enum Result<T, U> {
  case Success(value: T)
  case Failure(error: U)
}
```
but be aware this will preclude your API from being accessed by Objective-C. Where that is necessary, use a closure that returns an optional success and failure values.

## Protocol-Oriented design

* Use protocols wherever they make sense, and likely they should be your preferred type initially. See the WWDC session on [protocol oriented programming](https://developer.apple.com/videos/play/wwdc2015-408/). This is a common pattern in other languages, and will make it easier to keep code DRY and to make testing easier..

## MVVM
* Where appropriate, use an [MVVM](https://en.wikipedia.org/wiki/Model–view–viewmodel) pattern rather than a traditional MVC pattern to architect your apps. MVVM allows for cleaner, more testable code. A binding framework will to take full advantage of the pattern. Currently, we suggest using [Swift Bond](https://github.com/SwiftBond/Bond), but may change this recommendation if other libraries look better suited.

## Extensions and protocol extensions

Use extensions liberally. They are a good way to separate logical pieces of code, indicate protocol conformance, provide default functionality (particularly for protocol extensions), or help separate and define test cases. When extending classes with new functionality, particularly if extending framework classes, create the extension in a separate file.

## Testing

* `@testable` imports mean you don't need to mark everything as `public`, you can keep the default `internal` access control in most cases.
* [Nimble](https://github.com/Quick/Nimble) is a nice expectations framework for Swift, along the lines of expecta in Objective-C, but without needing macros.
* Code should be accompanied with a suitable level of unit testing. Ensure you are aware of the expected level and targets of code coverage before you start working on a project. As a minimum, Ordnance Survey expects around 80% code coverage.
* OCMock doesn't work well with Swift. Whilst it is possible to use from Objective-C tests on classes inheriting `NSObject`, consider the design of your API before resorting to this. Preferably, define your API using protocols, which will allow you to implement private classes within your test to create mocks and stubs. E.g:

```
func testItRequestsAnImage() {
    
    class MockImageCache: ImageSource {
        var receivedURL: NSURL?
        var completionHandler: ((ImageCacheResult) -> Void)?
        private func imageForURL(url: NSURL, completion: (ImageCacheResult) -> Void) {
            receivedURL = url
            completionHandler = completion
        }
    }
    
    let mockCache = MockImageCache()
    dataSource = LaunchStoryCollectionViewDataSource(imageSource: mockCache)
    // Test and assert
  }
}
```

## Comments and Documentation
* Code should be documented and commented as per the suggestions with [Objective-C](../Objective-C/README.md#4-comments), including the tools, which also work in swift.
* Code should be as self-documenting as possible. Use descriptive names for types, properties, methods. Follow Cocoa conventions as closely as possible when dealing with e.g. `UIKit`, and Swift standard library conventions when dealing with pure Swift code.
* Document anything that is non-obvious, hack-like, strange or a workaround.
