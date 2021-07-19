import Foundation

extension String {
  static func makeSlashText(_ text: String) -> NSAttributedString {
    let attributeString = NSMutableAttributedString(string: text)

    attributeString.addAttribute(
      NSAttributedString.Key.strikethroughStyle,
      value: 2,
      range: NSRange(location: 0, length: attributeString.length))

    return attributeString
  }
}
