//
//  ContentView.swift
//  SwiftUI Skew Effect
//
//  Created by Martin Albrecht on 02.03.24.
//

import SwiftUI


fileprivate let dummyBodyText = """
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis
natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque
eu, pretium quis, sem. Nulla consequat massa quis enim.\n\nDonec pede justo, fringilla vel, aliquet nec, vulputate eget,
arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium.
Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus.\n\nAenean leo ligula,
porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus.
Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue.
Curabitur ullamcorper ultricies nisi.\n\nLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo
ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo,
fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.
Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean
vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante,
dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean
imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas
tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc,
blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut
libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla
mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,
\n\nAliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.
Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui.
Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque
sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus.
Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt.
Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales,
augue velit cursus nunc, Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut
metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies
nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet
adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et
ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget
eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat,
leo eget bibendum sodales, augue velit cursus nunc,
"""

extension GeometryProxy {
    func scrollOffset() -> CGFloat {
        safeAreaInsets.top - frame(in: .global).minY
    }
}

extension Angle {
    static func offset(height: CGFloat, inset: CGFloat = 0) -> CGFloat {
        return 100 / (height + inset)
    }

    static func rotation(from geo: GeometryProxy, inset: CGFloat) -> Self {
        let scrollOffset = geo.scrollOffset()
        let translationOffset = offset(height: geo.size.height, inset: inset)
        return scrollOffset <= 0 ? .zero : .degrees(Double(scrollOffset * translationOffset))
    }
}

struct HeaderView: View {
    var title: String
    var subtitle: String

    private var insetHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        return windowScenes?.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.top ?? 0
    }

    var body: some View {
        GeometryReader { innerGeo in
            ZStack {
                VStack(spacing: 0) {
                    Group {
                        VStack(spacing: 10) {
                            Text(title)
                                .bold()
                                .font(.system(size: 45))
                                .padding(.top, 40)

                            Text(subtitle)
                                .bold()
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .padding(.top, innerGeo.size.height / 7)

                    Spacer()
                }

                Rectangle()
                    .fill(Color.black)
                    .opacity(shading(for: innerGeo))
                    .zIndex(1)
                    .frame(maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("Background").resizable().scaledToFill())
            .clipped()
            .rotation3DEffect(.rotation(from: innerGeo, inset: insetHeight), axis: (x: 1.0, y: 0, z: 0), anchor: .bottom)
        }
        .background(Color.black)
    }

    private func shading(for geo: GeometryProxy) -> Double {
        let translate = Angle.offset(height: geo.size.height, inset: insetHeight)
        return Double((geo.scrollOffset() * translate) / 100)
    }
}


struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeaderView(title: "Fancy Headline", subtitle: "And some fancy subheadline")
                    .frame(height: 350)

                // The plain text section
                Text(dummyBodyText)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(20)
                    .background(Color.white)
                    .foregroundColor(.black)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    ContentView()
}
