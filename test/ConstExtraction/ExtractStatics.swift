// RUN: %empty-directory(%t)
// RUN: echo "[MyProto]" > %t/protocols.json

// RUN: %target-swift-frontend -typecheck -emit-const-values-path %t/ExtractStatics.swiftconstvalues -const-gather-protocols-file %t/protocols.json -primary-file %s
// RUN: cat %t/ExtractStatics.swiftconstvalues 2>&1 | %FileCheck %s

protocol MyProto {}
protocol Foo {}

enum Bar: Foo {
    case one
    case two(item: String)
}

struct Baz: Foo {
    static var one: Baz {
        Baz()
    }

    static func two(item: String) -> Baz {
        return Baz()
    }
}

struct Statics: MyProto {
    var bar1 = Bar.one
    var bar2 = Bar.two(item: "bar")
    var baz1 = Baz.one
    var baz2 = Baz.two(item: "baz")

//    var items: [Foo] = [
//        Bar.one,
//        Bar.two(item: "bar"),
//        Baz.one,
//        Baz.two(item: "baz"),
//
//    ]
}

// CHECK:       "label": "bar1",
// CHECK-NEXT:  "type": "ExtractStatics.Bar",
// CHECK:       "valueKind": "Enum",
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "name": "one"
// CHECK-NEXT:  }
// CHECK:       "label": "bar2",
// CHECK-NEXT:  "type": "ExtractStatics.Bar",
// CHECK:       "valueKind": "Enum",
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "name": "two",
// CHECK-NEXT:    "arguments": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "label": "item",
// CHECK-NEXT:        "type": "Swift.String",
// CHECK-NEXT:        "valueKind": "RawLiteral",
// CHECK-NEXT:        "value": "bar"
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  }
// CHECK:       "label": "baz1",
// CHECK-NEXT:  "type": "ExtractStatics.Baz",
// CHECK:       "valueKind": "StaticCall"
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "type": "ExtractStatics.Baz",
// CHECK-NEXT:    "mangledName": "14ExtractStatics3BazV"
// CHECK-NEXT:  }
// CHECK:       "label": "baz2",
// CHECK-NEXT:  "type": "ExtractStatics.Baz",
// CHECK:       "valueKind": "Enum",
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "name": "two",
// CHECK-NEXT:    "arguments": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "label": "item",
// CHECK-NEXT:        "type": "Swift.String",
// CHECK-NEXT:        "valueKind": "RawLiteral",
// CHECK-NEXT:        "value": "baz"
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  }
