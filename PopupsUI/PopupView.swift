import UIKit

class PopupView: UIView {

    enum SourceEdge {
        case auto
        case top
        case bottom
    }

    private var backgroundView: UIView!
    private var contentView: UIView!

    private var sourceRect: CGRect = .zero
    private var sourceEdge: SourceEdge = .auto

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
        from source: UIView,
        in parent: UIView,
        sourceEdge: SourceEdge = .auto
    ) {
        guard let superview = source.superview else {
            return
        }

        self.sourceRect = superview.convert(source.frame, to: parent)
        self.sourceEdge = sourceEdge

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
        if sourceEdge == .top {
            return CGRect(
                x: sourceRect.minX + (sourceRect.width - size.width * scaleX) / 2,
                y: sourceRect.minY - size.height * scaleY,
                width: size.width * scaleX,
                height: size.height * scaleY
            )
        }

        return CGRect(
            x: sourceRect.minX + (sourceRect.width - size.width * scaleX) / 2,
            y: sourceRect.maxY,
            width: size.width * scaleX,
            height: size.height * scaleY
        )
    }

    private var frameEnd: CGRect {
        if sourceEdge == .top {
            return CGRect(
                x: sourceRect.maxX - size.width,
                y: sourceRect.minY - size.height,
                width: size.width,
                height: size.height
            )
        }

        return CGRect(
            x: sourceRect.maxX - size.width,
            y: sourceRect.maxY,
            width: size.width,
            height: size.height
        )
    }
}
