# Tokamak

## SwiftUI-compatible framework for building browser apps with WebAssembly

![CI status](https://github.com/swiftwasm/Tokamak/workflows/CI/badge.svg?branch=main)

At the moment Tokamak implements a very basic subset of SwiftUI. Its DOM renderer supports
a few view types, namely `Button`, `Text`, `HStack`/`VStack`, the `@State` property wrapper
and a new `HTML` view for constructing arbitrary HTML. The long-term goal of Tokamak is to implement
as much of SwiftUI API as possible and to provide a few more helpful additions that simplify HTML
and CSS interactions.

## Getting started

Tokamak relies on [`carton`](https://carton.dev) as a primary build tool. Please follow
[installation instructions](https://github.com/swiftwasm/carton#requirements) for `carton` first.

After `carton` is successfully installed, type `carton dev --product TokamakDemo` in the
root directory of the cloned Tokamak repository. This will build the demo project and its
dependencies and launch a development HTTP server. You can then open
[http://127.0.0.1:8080/](http://127.0.0.1:8080/) in your browser to interact with the demo.

### Example code

Tokamak API attempts to resemble SwiftUI API as much as possible. The main difference is
that you add `import TokamakDOM` instead of `import SwiftUI` in your files:

```swift
import TokamakDOM

struct Counter: View {
  @State public var count: Int
  let limit: Int

  var body: some View {
    count < limit ?
      AnyView(
        VStack {
          Button("Increment") { count += 1 }
          Text("\(count)")
        }
      ) : AnyView(
        VStack { Text("Limit exceeded") } }
      )
  }
}
```

You can then render your view in any DOM node captured with
[JavaScriptKit](https://github.com/kateinoigakukun/JavaScriptKit/), just
pass it as an argument to the `DOMRenderer` initializer together with your view:

```swift
import JavaScriptKit
import TokamakDOM

let document = JSObjectRef.global.document.object!

let divElement = document.createElement!("div").object!
let renderer = DOMRenderer(Counter(count: 5, limit: 15), divElement)

let body = document.body.object!
_ = body.appendChild!(divElement)
```

### Arbitrary HTML

With the `HTML` view you can also render any HTML you want, including inline SVG:

```swift
struct SVGCircle: View {
  var body: some View {
    HTML("svg", ["width": "100", "height": "100"]) {
      HTML("circle", [
        "cx": "50", "cy": "50", "r": "40",
        "stroke": "green", "stroke-width": "4", "fill": "yellow",
      ])
    }
  }
}
```

### Arbitrary styles and scripts

While `JavaScriptKit` is a great option for occasional interactions with JavaScript,
sometimes you need to inject arbitrary scripts or styles, which can be done through direct
DOM access:

```swift
let script = #"""
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.27.0/moment.min.js"></script>
"""#
let style = #"""
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css">
"""#
_ = document.head.object!.insertAdjacentHTML!("beforeend", JSValue(stringLiteral: style))
_ = document.head.object!.insertAdjacentHTML!("beforeend", JSValue(stringLiteral: script))
```

This way both [Semantic UI](https://semantic-ui.com/) styles and [moment.js](https://momentjs.com/)
localized date formatting (or any arbitrary style/script/font added that way) are available in your
app.

## Acknowledgments

- Thanks to the [Swift community](https://swift.org/community/) for
  building one of the best programming languages available!
- Thanks to [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI),
  [Render](https://github.com/alexdrone/Render),
  [ReSwift](https://github.com/ReSwift/ReSwift), [Katana
  UI](https://github.com/BendingSpoons/katana-ui-swift) and
  [Komponents](https://github.com/freshOS/Komponents) for inspiration!

## Contributing

This project adheres to the [Contributor Covenant Code of
Conduct](https://github.com/swiftwasm/Tokamak/blob/main/CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report
unacceptable behavior to conduct@tokamak.dev.

## Maintainers

[Max Desiatov](https://desiatov.com)

## License

Tokamak is available under the Apache 2.0 license. See the
[LICENSE](https://github.com/swiftwasm/Tokamak/blob/main/LICENSE) file for
more info.
