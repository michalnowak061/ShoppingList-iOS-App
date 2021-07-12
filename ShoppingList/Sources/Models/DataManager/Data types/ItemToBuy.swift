//
//  ItemToBuy.swift
//  ShoppingList
//
//  Created by Michał Nowak on 11/07/2021.
//

import Foundation
import RealmSwift

class ItemToBuy: Object {
  @objc dynamic var name = ""

  convenience init(name: String) {
    self.init()
    self.name = name
  }
}
