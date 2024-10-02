// RUN: %empty-directory(%t)
// RUN: echo "[MyProto]" > %t/protocols.json

// RUN: %target-swift-frontend -typecheck -emit-const-values-path %t/ExtractStaticVar.swiftconstvalues -const-gather-protocols-file %t/protocols.json -primary-file %s
// RUN: cat %t/ExtractStaticVar.swiftconstvalues 2>&1 | %FileCheck %s

protocol MyProto {}

struct Foo: MyProto {
    static let chest: StaticHolder = StaticHolder(.chests.chest)
    static let chestInt: StaticHolder = StaticHolder(Bar.bat.bat.bat.value)

    let number = Bar.bat.bat.bat.value

    static var entity: some StaticHolders.Entity {
        StaticHolders.ItemSchema.chests.chest
    }
}

struct Bar {
    static var bat: Bat { Bat() }
}

struct Bat {
    var bat: Bat { Bat() }
    var value: Int { 1 }
}

struct StaticHolder: Sendable {
    let identifier: String

    struct ItemSchema: StaticHolders.Entity {
        let identifier: String

        @usableFromInline
        init(_ identifier: String) {
            self.identifier = identifier
        }
    }

    init(_ schema: some StaticHolders.Entity) {
        self.identifier = (schema as! ItemSchema).identifier
    }

    init(_ number: Int) {
        self.identifier = "\(number)"
    }
}

enum StaticHolders {
    @_marker
    protocol Model {}

    @_marker
    protocol Entity: Model {}

    struct ItemSchema: Entity {}

}

extension StaticHolders {
    @_marker
    protocol ChestsEntity: StaticHolders.Model {}
}

extension StaticHolders.ItemSchema: StaticHolders.ChestsEntity {}

extension StaticHolder.ItemSchema: StaticHolders.ChestsEntity {}

extension StaticHolders.Entity where Self == StaticHolders.ItemSchema {
    static var chests: some StaticHolders.ChestsEntity {
        return StaticHolder.ItemSchema("chests")
    }
}

extension StaticHolders.ChestsEntity {
    var chest: some StaticHolders.Entity {
        return StaticHolder.ItemSchema("chest")
    }
}

// CHECK: -----
