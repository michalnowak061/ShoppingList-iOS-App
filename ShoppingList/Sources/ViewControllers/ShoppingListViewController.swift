import UIKit

class ShoppingListViewController: UIViewController {
  // MARK: - IBOutlet's
  @IBOutlet weak var addButton: UIButton!

  @IBOutlet weak var tableView: UITableView!

  // MARK: - Override function's
  override func loadView() {
    super.loadView()
    self.setup()
  }

  // MARK: - Private function's
  private func setup() {
    self.addButtonSetup()
    self.tableViewSetup()
  }

  private func addButtonSetup() {
    self.addButton.layer.cornerRadius = self.addButton.frame.width / 2
    self.addButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.3342734486, blue: 0.497093107, alpha: 1)
    self.addButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
  }

  private func tableViewSetup() {
    self.tableView.allowsSelection = false
    self.tableView.separatorStyle = .none
    self.tableView.showsVerticalScrollIndicator = false

    self.tableView.delegate = self
    self.tableView.dataSource = self
  }

  private func showAddItemToBuyAlert() {
    let alert = UIAlertController(
      title: "Add item to buy",
      message: nil,
      preferredStyle: .alert)

    alert.addTextField { textField in
      textField.placeholder = "Item name"
    }

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
      if let name = alert.textFields?.first?.text {
        print("Item to buy name: \(name)")
      }
    })

    self.present(alert, animated: true)
  }

  @IBAction func addButtonPressed(_ sender: UIButton) {
    self.showAddItemToBuyAlert()
  }
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as? ShoppingListTableViewCell
    else {
      fatalError("TaskTableViewCell identifier not found")
    }

    cell.taskName = "Item to buy name"

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    self.view.frame.height * 0.08
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, _  in
    }

    return UISwipeActionsConfiguration(actions: [action])
  }
}

extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
  func didSelect(taskTableViewCell: ShoppingListTableViewCell, didSelect: Bool) {
  }

  func didDeselect(taskTableViewCell: ShoppingListTableViewCell, didDeselect: Bool) {
  }
}
