import UIKit

class PopupView: UIView {

    enum OriginEdge {
        case auto
        case top
        case bottom
    }

    private var backgroundView: UIView!
    private var contentView: UIView!

    private var originFrame: CGRect = .zero
    private var originEdge: OriginEdge = .auto

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

    func setContentView(_ view: UIView) {
        if contentView != nil {
            contentView.removeFromSuperview()
        }

        contentView = view
        addSubview(view)

        NSLayoutConstraint.match(view: view, in: self)
    }

    func present(
        from origin: UIView,
        in parent: UIView,
        originEdge: OriginEdge = .auto
    ) {
        guard let superview = origin.superview else {
            return
        }

        self.originFrame = superview.convert(origin.frame, to: parent)
        self.originEdge = originEdge

        setupBackgroundView(in: parent)

        parent.addSubview(self)

        setupAnimationOut()

        animate {
            self.setupAnimationIn()
        }
    }

    private func setupBackgroundView(in parent: UIView) {
        backgroundView = UIView(frame: parent.bounds)
        backgroundView.alpha = 0.0
        backgroundView.backgroundColor = UIColor.black
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        parent.addSubview(backgroundView)

        NSLayoutConstraint.match(view: backgroundView, in: parent)
    }

    @objc
    private func dismiss() {
        animate {
            self.setupAnimationOut()
        } completion: {
            self.backgroundView.removeFromSuperview()
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
        transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        frame = frameStart
        alpha = 0.0

        backgroundView.alpha = 0.0

        layoutIfNeeded()
    }

    private func setupAnimationIn() {
        transform = .identity
        frame = frameEnd
        alpha = 1.0

        backgroundView.alpha = 0.1

        layoutIfNeeded()
    }

    var frameStart: CGRect {
        if originEdge == .top {
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
        if originEdge == .top {
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
