import SwiftUI

struct SampleButtonPopup: View {
    var body: some View {
        ButtonPopup(title: "Open Popup") {
            Text(SampleContent.text)
                .padding()
        }
    }
}

#Preview {
    HStack {
        Spacer()
        SampleButtonPopup()
    }
    .padding()
}
