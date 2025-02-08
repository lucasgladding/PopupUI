import SwiftUI

struct SamplePopupButton: View {
    var body: some View {
        PopupButton(title: "Open Popup") {
            Text(SampleContent.text)
                .padding()
        }
    }
}

#Preview {
    HStack {
        Spacer()
        SamplePopupButton()
    }
    .padding()
}
