import UIKit

class ShoppingListsViewController: UIViewController {
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
    self.tableView.separatorStyle = .none
    self.tableView.showsVerticalScrollIndicator = false

    self.tableView.delegate = self
    self.tableView.dataSource = self
  }

  private func showAddListAlert() {
    let alert = UIAlertController(
      title: "Add shopping list",
      message: nil,
      preferredStyle: .alert)

    alert.addTextField { textField in
      textField.placeholder = "Shopping list name"
    }

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
      if let name = alert.textFields?.first?.text {
        print("Shopping list name: \(name)")
      }
    })

    self.present(alert, animated: true)
  }

  // MARK: - IBAction's
  @IBAction func addButtonPressed(_ sender: UIButton) {
    self.showAddListAlert()
  }
}

extension ShoppingListsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = self.tableView.dequeueReusableCell(
        withIdentifier: "ShoppingListsTableViewCell") as? ShoppingListsTableViewCell
    else {
      fatalError("ShoppingListsTableViewCell identifier not found")
    }

    cell.nameLabel.text = "Shopping list name"

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
