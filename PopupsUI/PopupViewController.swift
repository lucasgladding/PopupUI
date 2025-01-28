import UIKit

class PopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .system)
        button.setTitle("Show Popup View", for: .normal)
        button.addTarget(self, action: #selector(showPopupView), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func showPopupView(sender: UIButton) {
        let popupView = PopupView()
        let container = createContainerView()
        popupView.replaceContentView(container)
        popupView.show(from: sender, in: view)
    }

    private func createContainerView() -> UIView {
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

// MARK: - Custom Popup View

class PopupView: UIView {

    private var backgroundView: UIView!

    private var buttonFrame: CGRect = .zero

    private let size = CGSize(width: 300, height: 300)

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        alpha = 0.0
    }

    func replaceContentView(_ view: UIView) {
        addSubview(view)
        NSLayoutConstraint.match(view: view, in: self)
    }

    func show(from button: UIButton, in parentView: UIView) {
        guard let superview = button.superview else {
            return
        }

        buttonFrame = superview.convert(button.frame, to: parentView)

        setupBackgroundView(in: parentView)

        parentView.addSubview(self)

        setupAnimationOut()

        animate {
            self.setupAnimationIn()
        }
    }

    private func setupBackgroundView(in parentView: UIView) {
        backgroundView = UIView(frame: parentView.bounds)
        backgroundView.alpha = 0.0
        backgroundView.backgroundColor = UIColor.black
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        parentView.addSubview(backgroundView)

        NSLayoutConstraint.match(view: backgroundView, in: parentView)
    }

    @objc func dismiss() {
        animate {
            self.setupAnimationOut()
        } completion: {
            self.backgroundView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

    func animate(
        animations: @escaping () -> Void,
        completion: @escaping () -> Void = {}
    ) {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut
        ) {
            animations()
        } completion: { _ in
            completion()
        }
    }

    private func setupAnimationOut() {
        let scaleX: CGFloat = 0.3

        alpha = 0.0
        transform = CGAffineTransform(scaleX: scaleX, y: 0.1)
        frame = frameStart(scaleX: 0.1)

        backgroundView.alpha = 0.0

        layoutIfNeeded()
    }

    private func setupAnimationIn() {
        alpha = 1.0
        transform = .identity
        frame = frameEnd()

        backgroundView.alpha = 0.1

        layoutIfNeeded()
    }

    private func frameStart(scaleX: CGFloat) -> CGRect {
        return CGRect(
            x: buttonFrame.minX + (buttonFrame.width - size.width * scaleX) / 2,
            y: buttonFrame.maxY,
            width: size.width * scaleX,
            height: size.height * 0.1
        )
    }

    private func frameEnd() -> CGRect {
        return CGRect(
            x: buttonFrame.maxX - size.width,
            y: buttonFrame.maxY,
            width: size.width,
            height: size.height
        )
    }
}
