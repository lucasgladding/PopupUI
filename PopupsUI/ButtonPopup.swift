import SwiftUI
import UIKit

struct ButtonPopup<Content: View>: View {
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
        ButtonPopupRepresentable(title: title, content: content)
    }
}

private struct ButtonPopupRepresentable<Content: View>: UIViewRepresentable {
    var title: String
    var content: () -> Content

    func makeCoordinator() -> Coordinator {
        Coordinator(content: content)
    }

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)

        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.present(_:)),
            for: .touchUpInside
        )

        return button
    }

    func updateUIView(_ button: UIButton, context: Context) {
        button.setTitle(title, for: .normal)
        context.coordinator.setContent(content())
    }

    func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: UIButton,
        context: Context
    ) -> CGSize? {
        return uiView.sizeThatFits(.zero)
    }

    class Coordinator {
        var contentController: UIHostingController<Content>

        init(content: @escaping () -> Content) {
            self.contentController = UIHostingController(rootView: content())
            self.contentController.view.translatesAutoresizingMaskIntoConstraints = false
            self.contentController.view.layer.cornerRadius = 10
        }

        func setContent(_ content: Content) {
            contentController.rootView = content
        }

        @objc
        func present(_ sender: UIButton) {
            let popupView = PopupView()
            popupView.setContentView(contentController.view)

            if let window = sender.window {
                popupView.present(from: sender, in: window)
            }
        }
    }
}

#Preview {
    SamplePopup()
}
