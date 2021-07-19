import XCTest
import RealmSwift
@testable import ShoppingList

class DataManagerTests: XCTestCase {
  // MARK: - Variable's
  var sut: DataManager!

  var mock: Realm!

  // MARK: - Override function's
  override func setUp() {
    super.setUp()
    self.mock = createRealmMock()
    self.sut = DataManager(realm: self.mock)
  }

  override func tearDown() {
    self.mock = nil
    self.sut = nil
    super.tearDown()
  }

  // MARK: - Test's
  func testInit() {
    XCTAssertNotNil(self.sut)
  }

  func testCreate() {
    self.sut.read()
    let count = self.sut.entities.count
    XCTAssertNoThrow(try self.sut.create(shoppingList: ShoppingList()))
    XCTAssertEqual(self.sut.entities.count, count + 1)
  }

  func testDeleteAll() {
    self.sut.read()
    XCTAssertNoThrow(try self.sut.create(shoppingList: ShoppingList()))
    XCTAssertNoThrow(try self.sut.deleteAll())
    XCTAssertEqual(self.sut.entities.count, 0)
  }

  func testEmptyCount() {
    self.sut.read()
    XCTAssertNoThrow(try self.sut.deleteAll())
    XCTAssertEqual(self.sut.entities.count, 0)
  }

  func testRead() {
    let list = ShoppingList()
    list.name = "List name"

    XCTAssertNoThrow(try self.sut.deleteAll())
    XCTAssertNoThrow(try self.sut.create(shoppingList: list))

    self.sut.read {
      XCTAssertEqual(self.sut.entities[0].name, "List name")
    }
  }

  func testFilter() {
    XCTAssertNoThrow(try self.sut.create(shoppingList: ShoppingList(name: "list 1", items: .init())))
    XCTAssertNoThrow(try self.sut.create(shoppingList: ShoppingList(name: "list 2", items: .init())))
    XCTAssertNoThrow(try self.sut.create(shoppingList: ShoppingList(name: "list 3", items: .init())))
    XCTAssertNoThrow(try self.sut.create(shoppingList: ShoppingList(name: "list 4", items: .init())))

    self.sut.filter(predicate: NSPredicate(format: "name = %@", "list 1")) {
      XCTAssertEqual(self.sut.entities.count, 1)
    }
  }

  func testUpdate() {
    let list = ShoppingList()
    list.name = "List name"

    XCTAssertNoThrow(try self.sut.deleteAll())
    XCTAssertNoThrow(try self.sut.create(shoppingList: list))

    self.sut.read()

    XCTAssertNoThrow(try self.sut.update(closure: {
      let list = self.sut.entities[0]
      list.name = "New list name"
    }, completion: {
      self.sut.read {
        XCTAssertEqual(self.sut.entities[0].name, "New list name")
      }
    }))
  }

  func testDelete() {
    self.sut.read()
    XCTAssertNoThrow(try self.sut.create(shoppingList: ShoppingList()))
    XCTAssertNoThrow(try self.sut.delete(atIndex: 0))
    XCTAssertEqual(self.sut.entities.count, 0)
  }

  func getTest() {
    let list = ShoppingList()
    list.name = "List name"

    XCTAssertNoThrow(try self.sut.deleteAll())
    XCTAssertNoThrow(try self.sut.create(shoppingList: list))

    self.sut.read {
      XCTAssertEqual(self.sut.entities[0].name, "List name")
    }
  }
}
