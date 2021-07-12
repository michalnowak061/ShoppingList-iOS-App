//
//  RealmMock.swift
//  ShoppingListTests
//
//  Created by Michał Nowak on 11/07/2021.
//

import Foundation
import RealmSwift

func createRealmMock() -> Realm? {
  do {
    let configuration = Realm.Configuration(inMemoryIdentifier: "inMemoryIdentifier")
    return try Realm(configuration: configuration)
  } catch {
    return nil
  }
}
