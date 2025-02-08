import UIKit
import SwiftUI

class SamplePopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let hostingController = UIHostingController(rootView: SampleButtonPopup())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.match(view: hostingController.view, in: view)
    }
}
