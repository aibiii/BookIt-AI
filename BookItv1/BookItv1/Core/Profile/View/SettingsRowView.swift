import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let backgroundColor: Color
    let iconColor: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor) // Set the background color
                    .frame(width: 44, height: 44)
                Image(systemName: imageName)
                    .imageScale(.small)
                    .font(.title)
                    .foregroundColor(iconColor) // Set the icon color
            }

            Text(title)
                .font(.custom("Roboto-Regular", size: 15))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(imageName: "paperplane.circle.fill",
                        title: "Test",
                        backgroundColor: .white,
                        iconColor: .blue)
    }
}
