import SwiftUI

struct SamplePopupButton: View {
    var body: some View {
        PopupButton(title: "Open Popup") {
            Text("Popup Content")
        }
    }
}

#Preview {
    SamplePopupButton()
}
