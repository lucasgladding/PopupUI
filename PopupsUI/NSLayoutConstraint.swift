import UIKit

extension NSLayoutConstraint {
    static func match(view: UIView, in parentView: UIView) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            view.topAnchor.constraint(equalTo: parentView.topAnchor),
            view.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            view.heightAnchor.constraint(equalTo: parentView.heightAnchor)
       ])
    }
}
