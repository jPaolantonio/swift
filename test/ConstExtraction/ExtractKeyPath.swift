// RUN: %empty-directory(%t)
// RUN: echo "[MyProto]" > %t/protocols.json

// RUN: %target-swift-frontend -typecheck -emit-const-values-path %t/ExtractKeyPaths.swiftconstvalues -const-gather-protocols-file %t/protocols.json -primary-file %s
// RUN: cat %t/ExtractKeyPaths.swiftconstvalues 2>&1 | %FileCheck %s

protocol MyProto {}

public struct MyType {
//    let constant: String
//    var variable: String
//
//    let nestedConstant: NestedType
    var nested: NestedOne

    struct NestedOne {
        var foo: NestedTwo
    }

    struct NestedTwo {
        var bar: NestedThree
    }

    struct NestedThree {
        var baz: String
    }
}

public struct KeyPaths: MyProto {
//    static let constant = \MyType.constant
//    static let variable = \MyType.variable
//    static let nestedConstant = \MyType.nestedConstant.foo
    static let nestedVariable = \MyType.nested.foo.bar.baz
}


// CHECK: [
// CHECK-NEXT:  {
// CHECK-NEXT:    "typeName": "ExtractKeyPath.KeyPaths",
// CHECK-NEXT:    "mangledTypeName": "14ExtractKeyPath0B5PathsV",
// CHECK-NEXT:    "kind": "struct",
// CHECK-NEXT:    "file": "{{.*}}test{{/|\\\\}}ConstExtraction{{/|\\\\}}ExtractKeyPath.swift",
// CHECK-NEXT:    "line": 14,
// CHECK-NEXT:    "conformances": [
// CHECK-NEXT:      "ExtractKeyPath.MyProto"
// CHECK-NEXT:    ],
// CHECK-NEXT:    "associatedTypeAliases": [],
// CHECK:         "properties": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "label": "constant",
// CHECK-NEXT:        "type": "Swift.KeyPath<ExtractKeyPath.MyType, Swift.String>",
// CHECK-NEXT:        "mangledTypeName": "n/a - deprecated",
// CHECK-NEXT:        "isStatic": "true",
// CHECK-NEXT:        "isComputed": "false",
// CHECK-NEXT:        "file": "{{.*}}test{{/|\\\\}}ConstExtraction{{/|\\\\}}ExtractKeyPath.swift",
// CHECK-NEXT:        "line": 15,
// CHECK-NEXT:        "valueKind": "KeyPath"
// CHECK-NEXT:      },
// CHECK-NEXT:      {
// CHECK-NEXT:        "label": "variable",
// CHECK-NEXT:        "type": "Swift.WritableKeyPath<ExtractKeyPath.MyType, Swift.String>",
// CHECK-NEXT:        "mangledTypeName": "n/a - deprecated",
// CHECK-NEXT:        "isStatic": "true",
// CHECK-NEXT:        "isComputed": "false",
// CHECK-NEXT:        "file": "{{.*}}test{{/|\\\\}}ConstExtraction{{/|\\\\}}ExtractKeyPath.swift",
// CHECK-NEXT:        "line": 16,
// CHECK-NEXT:        "valueKind": "KeyPath"
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  }
// CHECK-NEXT:]
