import Foundation
import RealmSwift

class DataManager {
  private var realm: Realm!

  private(set) var entities: Results<ShoppingList>!

  init?() {
    do {
      try self.realm = Realm()

      #if DEBUG
      if let url = self.realm.configuration.fileURL {
        print("Realm database file path: ", url)
      }
      #endif
    } catch {
      return nil
    }
  }

  // periphery: ignore
  convenience init?(realm: Realm) {
    self.init()
    self.realm = realm
  }

  func create(shoppingList list: ShoppingList, completion: @escaping () -> Void = {}) throws {
    try DispatchQueue.init(label: "create", qos: .background).sync {
      do {
        try self.realm.write {
          self.realm.add(list)
        }
      } catch {
        throw error
      }

      completion()
    }
  }

  func read(completion: @escaping () -> Void = {}) {
    DispatchQueue.init(label: "read", qos: .background).sync {
      self.entities = self.realm.objects(ShoppingList.self)
      completion()
    }
  }

  func filter(predicate: NSPredicate, completion: @escaping () -> Void = {}) {
    DispatchQueue.init(label: "filter", qos: .background).sync {
      self.entities = self.realm.objects(ShoppingList.self).filter(predicate)
      completion()
    }
  }

  func update(closure: @escaping () -> Void, completion: @escaping () -> Void = {}) throws {
    try DispatchQueue.init(label: "update", qos: .background).sync {
      do {
        try self.realm.write {
          closure()
        }
      } catch {
        throw error
      }

      completion()
    }
  }

  func delete(atIndex index: Int, completion: @escaping () -> Void = {}) throws {
    try DispatchQueue.init(label: "delete", qos: .background).sync {
      let list = self.realm.objects(ShoppingList.self)[index]

      do {
        try self.realm.write {
          self.realm.delete(list)
        }
      } catch {
        throw error
      }

      completion()
    }
  }

  // periphery:ignore
  func deleteAll(completion: @escaping () -> Void = {}) throws {
    try DispatchQueue.init(label: "deleteAll", qos: .background).sync {
      do {
        try self.realm.write {
          self.realm.deleteAll()
        }
      } catch {
        throw error
      }

      completion()
    }
  }
}
