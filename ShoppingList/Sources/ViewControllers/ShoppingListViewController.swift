import UIKit

class ShoppingListViewController: UIViewController {
  // MARK: - Private var
  private var dataManager: DataManager!

  private var selectedIndex: Int!

  private var selectedShoppingList: ShoppingList {
    self.dataManager.entities[self.selectedIndex]
  }

  // MARK: - IBOutlet's
  @IBOutlet weak var addButton: UIButton!

  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var titleLabel: UILabel!

  // MARK: - Override function's
  override func loadView() {
    super.loadView()
    self.setup()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.updateUI()
  }

  // MARK: - Function's
  func setRequiredData(dataManager: DataManager, selectedIndex: Int) {
    self.dataManager = dataManager
    self.selectedIndex = selectedIndex
  }

  // MARK: - Private function's
  private func setup() {
    self.setupTitleLabel()
    self.addButtonSetup()
    self.tableViewSetup()
  }

  private func setupTitleLabel() {
    let shoppingList = self.dataManager.entities[self.selectedIndex]
    self.titleLabel.text = shoppingList.name
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

  private func updateUI() {
    self.dataManager.read {
      self.tableView.reloadData()
    }
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
        do {
          try self.dataManager.update(closure: {
            let newItemToBuy = ItemToBuy()
            newItemToBuy.name = name

            let list = self.selectedShoppingList
            list.items.append(newItemToBuy)
          }, completion: {
            self.updateUI()
          })
        } catch {
          fatalError(error.localizedDescription)
        }
      }
    })

    self.present(alert, animated: true)
  }

  // MARK: - IBAction's
  @IBAction func addButtonPressed(_ sender: UIButton) {
    self.showAddItemToBuyAlert()
  }
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.selectedShoppingList.items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = self.tableView.dequeueReusableCell(
        withIdentifier: "ShoppingListTableViewCell") as? ShoppingListTableViewCell
    else {
      fatalError("ShoppingListTableViewCell identifier not found")
    }

    let item = self.selectedShoppingList.items[indexPath.row]
    cell.itemToBuyName = item.name

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    self.view.frame.height * 0.08
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, _  in
      do {
        try self.dataManager.update(closure: {
          let list = self.selectedShoppingList
          list.items.remove(at: indexPath.row)
        }, completion: {
          self.updateUI()
        })
      } catch {
        fatalError(error.localizedDescription)
      }
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
