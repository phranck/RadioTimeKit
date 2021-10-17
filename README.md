[![RadioTimeKit CI](https://github.com/phranck/RadioTimeKit/actions/workflows/RadioTimeKit.yml/badge.svg)](https://github.com/phranck/RadioTimeKit/actions/workflows/RadioTimeKit.yml)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Tag](https://img.shields.io/github/tag/phranck/RadioTimeKit.svg?color=blue&label=Release)

<div align="center"><img src="RadioTimeBanner.svg" width="100%" /></div>

# RadioTimeKit - The Swift SDK for TuneIn

RadioTimeKit is a Swift package to use the TuneIn API. The goal for development was to have a Swift SDK to get convenient access to TuneIn's browsing and tuning API.

## Installation
`RadioTimeKit.git` works with Swift 5.3 and above for iOS and macOS (currently).

### Swift Package Manager

```Swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(url: "https://github.com/phranck/RadioTimeKit.git", from: "0.1.0"),
  ]
)
```

### Carthage
Put this in your `Cartfile`:

```
github "phranck/RadioTimeKit" ~> 0.1
```

## Developer Notes
`RadioTimeKit` uses [GitFlow](http://githubflow.github.io). There are two branches, `main` and `develop`. The `develop` branch is the default branch. To provide (*changes*|*fixes*|*additions*) you just have to fork this repository and create your working branch with `develop` as base. If you’re done, just open a pull request.

The API responses of TuneIn follows the [OPML Specification](http://opml.org/spec2.opml).

## Contact

* :envelope: [Write me an email](mailto:hello@woodbytes.me)
* :bird: [Ping me on Twitter](https://twitter.com/_Woodbytes_)
* :memo: [Read my blog](https://woodbytes.me)

## License
This software is published under the [MIT License](http://cocoanaut.mit-license.org).
