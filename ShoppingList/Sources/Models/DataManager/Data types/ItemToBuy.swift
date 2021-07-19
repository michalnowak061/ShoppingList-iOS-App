import Foundation
import RealmSwift

class ItemToBuy: Object {
  @objc dynamic var name = ""

  @objc dynamic var isChecked = false

  // periphery: ignore
  convenience init(name: String, isChecked: Bool) {
    self.init()
    self.name = name
    self.isChecked = isChecked
  }
}
