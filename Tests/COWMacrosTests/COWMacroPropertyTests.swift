//
//  COWMacroPropertyTests.swift
//
//
//  Created by nocchijiang on 2024/1/10.
//
//

@_implementationOnly import SwiftSyntaxMacros
@_implementationOnly import SwiftSyntaxMacrosTestSupport
@_implementationOnly import XCTest

@testable import COWMacros

final class COWMacroPropertyTests: XCTestCase {

  func testNotExpandingSetterForLetBinding() {
    assertMacroExpansion(
      """
      @COW
      struct Bar {
        let foo: Int

        init(foo: Int) {
          self._$storage = _$COWStorage(foo: foo)
        }
      }
      """,
      expandedSource:
      """
      struct Bar {
        let foo: Int {
          _read {
            yield _$storage.foo
          }
        }

        init(foo: Int) {
          self._$storage = _$COWStorage(foo: foo)
        }
        struct _$COWStorage: COW.CopyOnWriteStorage {
          let foo: Int
        }
        @COW._Box
        var _$storage: _$COWStorage
      }
      """,
      macros: testedMacros,
      indentationWidth: .spaces(2)
    )
  }

}
