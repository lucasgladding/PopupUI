import UIKit

class SamplePopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }

    private func setupButton() {
        let button = createButton()
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createButton() -> UIView {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Popup View", for: .normal)
        button.addTarget(self, action: #selector(showPopupView), for: .touchUpInside)

        return button
    }

    @objc func showPopupView(sender: UIButton) {
        let popupView = PopupView()
        let container = createContainer()
        popupView.replaceContent(container)

        popupView.present(from: sender, in: view)
    }

    private func createContainer() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        container.layer.backgroundColor = UIColor.white.cgColor
        container.layer.cornerRadius = 10
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowRadius = 50

        let label = UILabel()
        label.text = SampleContent.text
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        NSLayoutConstraint.match(view: label, in: container)

        return container
    }
}
