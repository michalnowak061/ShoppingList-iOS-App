import Foundation
import RealmSwift

class ItemToBuy: Object {
  @objc dynamic var name = ""

  convenience init(name: String) {
    self.init()
    self.name = name
  }
}
