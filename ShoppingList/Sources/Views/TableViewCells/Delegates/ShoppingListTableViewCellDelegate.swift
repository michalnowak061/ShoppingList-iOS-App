import Foundation

protocol ShoppingListTableViewCellDelegate: AnyObject {
  func didSelect(taskTableViewCell: ShoppingListTableViewCell)

  func didDeselect(taskTableViewCell: ShoppingListTableViewCell)
}
