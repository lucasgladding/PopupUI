import UIKit

class PopupView: UIView {

    enum Anchor {
        case auto
        case top
        case bottom
    }

    private var anchor: Anchor = .auto

    private var background: UIView!

    private var content: UIView!

    private var originFrame: CGRect = .zero

    private var size: CGSize = CGSize(width: 300, height: 300)

    private let scaleX: CGFloat = 0.3

    private let scaleY: CGFloat = 0.1

    init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        alpha = 0.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func replaceContent(_ view: UIView) {
        if content != nil {
            content.removeFromSuperview()
        }
        content = view
        addSubview(view)
        NSLayoutConstraint.match(view: view, in: self)
    }

    func present(
        from origin: UIView,
        in parent: UIView,
        anchor: Anchor = .auto
    ) {
        guard let superview = origin.superview else {
            return
        }

        self.anchor = anchor
        originFrame = superview.convert(origin.frame, to: parent)

        setupBackground(in: parent)

        parent.addSubview(self)

        setupAnimationOut()

        animate {
            self.setupAnimationIn()
        }
    }

    private func setupBackground(in parent: UIView) {
        background = UIView(frame: parent.bounds)
        background.alpha = 0.0
        background.backgroundColor = UIColor.black
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        parent.addSubview(background)

        NSLayoutConstraint.match(view: background, in: parent)
    }

    @objc
    private func dismiss() {
        animate {
            self.setupAnimationOut()
        } completion: {
            self.background.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

    private func animate(
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
        alpha = 0.0
        transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        frame = frameStart

        background.alpha = 0.0

        layoutIfNeeded()
    }

    private func setupAnimationIn() {
        alpha = 1.0
        transform = .identity
        frame = frameEnd

        background.alpha = 0.1

        layoutIfNeeded()
    }

    var frameStart: CGRect {
        if anchor == .top {
            return CGRect(
                x: originFrame.minX + (originFrame.width - size.width * scaleX) / 2,
                y: originFrame.minY - size.height * scaleY,
                width: size.width * scaleX,
                height: size.height * scaleY
            )
        }

        return CGRect(
            x: originFrame.minX + (originFrame.width - size.width * scaleX) / 2,
            y: originFrame.maxY,
            width: size.width * scaleX,
            height: size.height * scaleY
        )
    }

    private var frameEnd: CGRect {
        if anchor == .top {
            return CGRect(
                x: originFrame.maxX - size.width,
                y: originFrame.minY - size.height,
                width: size.width,
                height: size.height
            )
        }

        return CGRect(
            x: originFrame.maxX - size.width,
            y: originFrame.maxY,
            width: size.width,
            height: size.height
        )
    }
}
