import UIKit
import MBCheckboxButton

class ShoppingListTableViewCell: UITableViewCell {
  // MARK: - Variable's
  var id: Int?

  weak var delegate: ShoppingListTableViewCellDelegate?

  var isChecked: Bool {
    get {
      return self.checkbox.isOn
    }
    set {
      self.checkbox.isOn = newValue
    }
  }

  var itemToBuyName: String? {
    get {
      return self.label.text
    }
    set {
      self.label.attributedText = nil
      self.label.text = newValue
    }
  }

  // MARK: - IBOutlet's
  @IBOutlet weak var checkbox: CheckboxButton!

  @IBOutlet weak var label: UILabel!

  // MARK: - Override function's
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.setup()

    switch self.checkbox.isOn {
    case true:
      self.select()
    case false:
      self.deselect()
    }
  }

  // MARK: - Private function's
  private func setup() {
    self.setupCheckbox()
    self.setupLabel()
  }

  private func setupCheckbox() {
    self.checkbox.style = .circle
    self.checkbox.checkboxLine = CheckboxLineStyle(checkBoxHeight: self.frame.height * 0.5)

    self.checkbox.checkBoxColor = CheckBoxColor(
      activeColor: #colorLiteral(red: 0.9686274529, green: 0.3342734486, blue: 0.497093107, alpha: 1),
      inactiveColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
      inactiveBorderColor: #colorLiteral(red: 0.9686274529, green: 0.3342734486, blue: 0.497093107, alpha: 1),
      checkMarkColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))

    self.checkbox.delegate = self
  }

  private func setupLabel() {
    self.label.adjustsFontSizeToFitWidth = true
    self.label.numberOfLines = 0
  }

  private func select() {
    if let text = self.label.text {
      UIView.animate(withDuration: 0.5) {
        self.label.attributedText = String.makeSlashText(text)
        self.label.alpha = 0.5
      }

      self.delegate?.didSelect(taskTableViewCell: self)
    }
  }

  private func deselect() {
    if let text = self.label.text {
      UIView.animate(withDuration: 0.5) {
        self.label.attributedText = NSMutableAttributedString(string: text)
        self.label.alpha = 1.0
      }

      self.delegate?.didDeselect(taskTableViewCell: self)
    }
  }
}

extension ShoppingListTableViewCell: CheckboxButtonDelegate {
  func chechboxButtonDidSelect(_ button: CheckboxButton) {
    self.select()
  }

  func chechboxButtonDidDeselect(_ button: CheckboxButton) {
    self.deselect()
  }
}
