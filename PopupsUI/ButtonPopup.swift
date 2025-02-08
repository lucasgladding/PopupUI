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

        context.coordinator.content = content
    }

    func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: UIButton,
        context: Context
    ) -> CGSize? {
        return uiView.sizeThatFits(.zero)
    }

    class Coordinator {
        var content: () -> Content

        init(content: @escaping () -> Content) {
            self.content = content
        }

        @objc
        func present(_ sender: UIButton) {
            let contentController = UIHostingController(rootView: content())

            guard let view = contentController.view else {
                return
            }

            view.translatesAutoresizingMaskIntoConstraints = false

            view.layer.cornerRadius = 10

            let popupView = PopupView()
            popupView.setContentView(view)

            if let window = sender.window {
                popupView.present(from: sender, in: window)
            }
        }
    }
}

#Preview {
    SampleButtonPopup()
}
