import Foundation

protocol ShoppingListTableViewCellDelegate: AnyObject {
  func didSelect(taskTableViewCell: ShoppingListTableViewCell, didSelect: Bool)

  func didDeselect(taskTableViewCell: ShoppingListTableViewCell, didDeselect: Bool)
}
