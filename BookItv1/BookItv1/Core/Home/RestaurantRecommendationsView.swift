import SwiftUI

struct RestaurantRecommendationsView: View {
    var body: some View {
        VStack {
            Text("Recommendations")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.21176470588235294, green: 0.21176470588235294, blue: 0.20784313725490197))
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 50) {
                    
                    NavigationLink(destination: Restaurant3DetailView()) {
                        CardView(
                            title: "Modè",
                            description: "Ресторан",
                            imageName: "restaurant3Logo",
                            backgroundColor: Color(hex: "#EEEAE4")
                        )
                    }
                    NavigationLink(destination: Restaurant4DetailView()) {
                        CardView(
                            title: "Santai gastrobar",
                            description: "Ресто-бар",
                            imageName: "restaurant4Logo",
                            backgroundColor: Color(hex: "#DAD6CF")
                        )
                    }
                    NavigationLink(destination: Restaurant2DetailView()) {
                        CardView(
                            title: "KIM CHI",
                            description: "Корейское кафе",
                            imageName: "restaurant2Logo",
                            backgroundColor: Color(hex: "#8B8985")
                        )
                    }
                    
                    NavigationLink(destination: Restaurant1DetailView()) {
                        CardView(
                            title: "Ристоран",
                            description: "Ресторан",
                            imageName: "restaurant1Logo",
                            backgroundColor: Color(hex: "#DAD6CF")
                        )
                    }
                    NavigationLink(destination: Restaurant5DetailView()) {
                        CardView(
                            title: "JamBull",
                            description: "Ресто-бар",
                            imageName: "restaurant5Logo",
                            backgroundColor: Color(hex: "#8B8985")
                        )
                    }
                }
                .padding(.leading)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 50) {
                    NavigationLink(destination: Salon1DetailView()) {
                        CardView(
                            title: "Montebello",
                            description: "Салон красоты",
                            imageName: "salon1Logo",
                            backgroundColor: Color(hex: "#8B8985")
                        )
                    }
                    NavigationLink(destination: Salon2DetailView()) {
                        CardView(
                            title: "NickOl Beauty Space",
                            description: "​Салон красоты",
                            imageName: "salon2Logo",
                            backgroundColor: Color(hex: "#EEEAE4")
                        )
                    }
                    NavigationLink(destination: Salon3DetailView()) {
                        CardView(
                            title: "Ness Beauty place",
                            description: "​Салон красоты",
                            imageName: "salon3Logo",
                            backgroundColor: Color(hex: "#DAD6CF")
                        )
                    }
                    NavigationLink(destination: Salon4DetailView()) {
                        CardView(
                            title: "Briolin Barbershop",
                            description: "​Барбершоп",
                            imageName: "salon4Logo",
                            backgroundColor: Color(hex: "#EEEAE4")
                        )
                    }
                    NavigationLink(destination: Salon5DetailView()) {
                        CardView(
                            title: "Yellow Cosmetology",
                            description: "​Центр косметологии",
                            imageName: "salon5Logo",
                            backgroundColor: Color(hex: "#8B8985")
                        )
                    }
                }
                .padding(.leading)
            }
            .padding(.horizontal)
        }
        .accentColor(Color(red: 0.21176470588235294, green: 0.21176470588235294, blue: 0.20784313725490197))
    }
}


struct CardView: View {
    var title: String
    var description: String
    var imageName: String
    var backgroundColor: Color

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
                .cornerRadius(12)

            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 150)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .lineLimit(2)
            }
            .padding()
        }
        .frame(width: 200, height: 250)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}


extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(
            red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgbValue & 0x0000FF) / 255.0
        )
    }
}

struct RestaurantRecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRecommendationsView()
    }
}
