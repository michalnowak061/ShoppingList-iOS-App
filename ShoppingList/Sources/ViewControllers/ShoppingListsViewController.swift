import UIKit
import JJFloatingActionButton

class ShoppingListsViewController: UIViewController {
  // MARK: - Private variable's
  private var dataManager: DataManager!

  private var selectedIndex: Int!

  // MARK: - Variable's
  var floatButton: JJFloatingActionButton!

  // MARK: - IBOutlet's
  @IBOutlet weak var tableView: UITableView!

  // MARK: - Override function's
  init() {
    super.init(nibName: nil, bundle: nil)
    self.dataManager = DataManager()
  }

  convenience init(dataManager: DataManager) {
    self.init()
    self.dataManager = dataManager
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.dataManager = DataManager()
  }

  override func loadView() {
    super.loadView()
    self.setup()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.updateUI()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showShoppingListVC" {
      if let viewController = segue.destination as? ShoppingListViewController {
        viewController.setRequiredData(dataManager: self.dataManager, selectedIndex: self.selectedIndex)
      }
    }
  }

  // MARK: - Private function's
  private func setup() {
    self.floatButtonSetup()
    self.tableViewSetup()
  }

  private func floatButtonSetup() {
    self.floatButton = JJFloatingActionButton()
    self.floatButton.buttonColor = #colorLiteral(red: 0.9686274529, green: 0.3342734486, blue: 0.497093107, alpha: 1)
    self.floatButton.translatesAutoresizingMaskIntoConstraints = false

    self.floatButton.addItem(
      title: "Add new list",
      image: (UIImage(systemName: "plus") ?? UIImage())?.withRenderingMode(.alwaysTemplate)) { _ in
      self.showAddListAlert()
      self.floatButton.close()
    }

    self.floatButton.addItem(
      title: "Search list",
      image: (UIImage(systemName: "magnifyingglass") ?? UIImage())?.withRenderingMode(.alwaysTemplate)) { _ in

      self.floatButton.close()
    }

    self.view.addSubview(self.floatButton)

    // constraints
    let offset = self.view.frame.width * 0.1
    let constraints = [
      self.floatButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -offset),
      self.floatButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -offset),
      self.floatButton.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.18),
      self.floatButton.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  private func tableViewSetup() {
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
        let newShoppingList = ShoppingList()
        newShoppingList.name = name

        do {
          try self.dataManager.create(shoppingList: newShoppingList) {
            self.updateUI()
          }
        } catch {
          fatalError(error.localizedDescription)
        }
      }
    })

    self.present(alert, animated: true)
  }
}

extension ShoppingListsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.dataManager.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = self.tableView.dequeueReusableCell(
        withIdentifier: "ShoppingListsTableViewCell") as? ShoppingListsTableViewCell
    else {
      fatalError("ShoppingListsTableViewCell identifier not found")
    }

    let list = self.dataManager.entities[indexPath.row]
    cell.nameLabel.text = list.name
    cell.selectionStyle = .none

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    self.view.frame.height * 0.08
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedIndex = indexPath.row
    self.performSegue(withIdentifier: "showShoppingListVC", sender: self)
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
      do {
        try self.dataManager.delete(atIndex: indexPath.row) {
          self.updateUI()
        }
      } catch {
        fatalError(error.localizedDescription)
      }
    }

    return UISwipeActionsConfiguration(actions: [action])
  }
}
