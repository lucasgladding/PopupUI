import SwiftUI

struct SamplePopup: View {
    var body: some View {
        VStack {
            ButtonPopup(title: "Open Popup") {
                Text(SampleContent.text)
            }
            CustomInput(title: "Open Input") {
                Text(SampleContent.text)
            }
        }
        .padding()
    }
}

#Preview {
    SamplePopup()
}
