import Foundation
import RealmSwift

class ShoppingList: Object {
  @objc dynamic var name = ""

  var items = List<ItemToBuy>()

  // periphery:ignore
  convenience init(name: String, items: List<ItemToBuy>) {
    self.init()
    self.name = name
    self.items = items
  }
}
