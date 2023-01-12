// RUN: %empty-directory(%t)
// RUN: echo "[MyProto]" > %t/protocols.json

// RUN: %target-swift-frontend -typecheck -emit-const-values-path %t/ExtractEnums.swiftconstvalues -const-gather-protocols-file %t/protocols.json -primary-file %s
// RUN: cat %t/ExtractEnums.swiftconstvalues 2>&1 | %FileCheck %s

protocol MyProto {}

public enum SimpleEnum: MyProto {
    case hello
    case world
}

public enum StringEnum: String, MyProto {
    case first, second
    case third = "bronzeMedal"
}

public enum AssociatedEnums: MyProto {
    case first(title: String)
    case second(Int)
}

// CHECK: [
// CHECK-NEXT:  {
// CHECK-NEXT:    "typeName": "ExtractEnums.SimpleEnum",
// CHECK-NEXT:    "kind": "enum",
// CHECK-NEXT:    "file": "{{.*}}test{{/|\\\\}}ConstExtraction{{/|\\\\}}ExtractEnums.swift",
// CHECK-NEXT:    "line": 9,
// CHECK-NEXT:    "properties": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "label": "hashValue",
// CHECK-NEXT:        "type": "Swift.Int",
// CHECK-NEXT:        "isStatic": "false",
// CHECK-NEXT:        "isComputed": "true",
// CHECK-NEXT:        "valueKind": "Runtime"
// CHECK-NEXT:      }
// CHECK-NEXT:    ],
// CHECK-NEXT:    "cases": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "name": "hello"
// CHECK-NEXT:      },
// CHECK-NEXT:      {
// CHECK-NEXT:        "name": "world"
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  },
// CHECK-NEXT:  {
// CHECK-NEXT:    "typeName": "ExtractEnums.StringEnum",
// CHECK-NEXT:    "kind": "enum",
// CHECK-NEXT:    "file": "{{.*}}test{{/|\\\\}}ConstExtraction{{/|\\\\}}ExtractEnums.swift",
// CHECK-NEXT:    "line": 14,
// CHECK-NEXT:    "properties": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "label": "rawValue",
// CHECK-NEXT:        "type": "Swift.String",
// CHECK-NEXT:        "isStatic": "false",
// CHECK-NEXT:        "isComputed": "true",
// CHECK-NEXT:        "valueKind": "Runtime"
// CHECK-NEXT:      }
// CHECK-NEXT:    ],
// CHECK-NEXT:    "cases": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "name": "first",
// CHECK-NEXT:        "rawValue": "first"
// CHECK-NEXT:      },
// CHECK-NEXT:      {
// CHECK-NEXT:        "name": "second",
// CHECK-NEXT:        "rawValue": "second"
// CHECK-NEXT:      },
// CHECK-NEXT:      {
// CHECK-NEXT:        "name": "third",
// CHECK-NEXT:        "rawValue": "bronzeMedal"
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  },
// CHECK-NEXT:  {
// CHECK-NEXT:    "typeName": "ExtractEnums.AssociatedEnums",
// CHECK-NEXT:    "kind": "enum",
// CHECK-NEXT:    "file": "{{.*}}test{{/|\\\\}}ConstExtraction{{/|\\\\}}ExtractEnums.swift",
// CHECK-NEXT:    "line": 19,
// CHECK-NEXT:    "properties": [],
// CHECK-NEXT:    "cases": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "name": "first",
// CHECK-NEXT:        "parameters": [
// CHECK-NEXT:          {
// CHECK-NEXT:            "label": "title",
// CHECK-NEXT:            "type": "Swift.String"
// CHECK-NEXT:          }
// CHECK-NEXT:        ]
// CHECK-NEXT:      },
// CHECK-NEXT:      {
// CHECK-NEXT:        "name": "second",
// CHECK-NEXT:        "parameters": [
// CHECK-NEXT:          {
// CHECK-NEXT:            "type": "Swift.Int"
// CHECK-NEXT:          }
// CHECK-NEXT:        ]
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  }
// CHECK-NEXT:]
