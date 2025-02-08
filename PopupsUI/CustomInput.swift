import UIKit
import SwiftUI

struct CustomInput<Content: View>: View {
    var title: String
    var content: () -> Content

    init(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content
    }

    var body: some View {
        CustomInputRepresentable(title: title, content: content)
    }
}

class CustomInputControl: UIControl {
    private var _inputView: UIView?

    override var inputView: UIView? {
        get {
            _inputView
        }
        set {
            _inputView = newValue
        }
    }

    private var label: UILabel!

    init(title: String) {
        super.init(frame: .zero)

        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.match(view: label, in: self)

        addTarget(self, action: #selector(onSelect), for: .touchUpInside)

        label.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        self.label.text = title
    }

    // LAYOUT

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return label.sizeThatFits(.zero)
    }

    // INTERACTIONS

    override var canBecomeFirstResponder: Bool {
        return true
    }

    @objc
    private func onSelect() {
        becomeFirstResponder()
    }
}

struct CustomInputRepresentable<Content: View>: UIViewRepresentable {
    var title: String
    var content: () -> Content

    func makeCoordinator() -> Coordinator {
        Coordinator(content: content)
    }

    func makeUIView(context: Context) -> CustomInputControl {
        let control = CustomInputControl(title: title)
        control.inputView = context.coordinator.contentController.view
        return control
    }

    func updateUIView(_ control: CustomInputControl, context: Context) {
        control.setTitle(title)
        context.coordinator.setContent(content())
    }

    class Coordinator {
        var contentController: UIHostingController<Content>

        init(content: @escaping () -> Content) {
            self.contentController = UIHostingController(rootView: content())
            self.contentController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        }

        func setContent(_ content: Content) {
            contentController.rootView = content
        }
    }
}
