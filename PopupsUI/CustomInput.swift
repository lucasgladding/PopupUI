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

struct CustomInputRepresentable<Content: View>: UIViewRepresentable {
    var title: String
    var content: () -> Content

    func makeCoordinator() -> Coordinator {
        Coordinator(content: content)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()

        textField.inputView = context.coordinator.contentController.view

        return textField
    }

    func updateUIView(_ textField: UITextField, context: Context) {
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
