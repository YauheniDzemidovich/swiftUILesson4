//
//  ContentView.swift
//  swiftUILesson4
//
//  Created by Yauheni Dzemidovich on 9.10.23.
//

import SwiftUI

private enum Settings {
    static let elementSize = 30.0
    static let paddingValue = 40.0
    static let duration = 0.22
    static let scale = 0.86
    static let imageName = "play.fill"
}

struct ButtonAnnimationStyle: ButtonStyle {
    @State private var isAnimation = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Circle()
                    .foregroundColor(.gray.opacity(isAnimation ? 0.5: .zero))
                    .frame(width: 100, height: 100)
            )
            .onChange(of: configuration.isPressed) { _ in
                print("onChange start animation")
                isAnimation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + Settings.duration) {
                    isAnimation = false
                }
            }
            .scaleEffect(isAnimation ? Settings.scale : 1)
            .animation(.linear(duration: Settings.duration), value: isAnimation)
    }
}

struct NextTrackButton: View {

    @Binding var performAnimation: Bool

    var body: some View {
        Button {
            if !performAnimation {
                withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)) {
                    print("animation")
                    performAnimation = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + Settings.duration) {
                        performAnimation = false
                    }
                }
            }
        } label: {
            GeometryReader { proxy in
                
                let width = proxy.size.width / 2
                let systemName = "play.fill"
                
                ZStack {
                    HStack(alignment: .center, spacing: 0) {
                        Image(systemName: systemName)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: performAnimation ? width : .zero)
                            .opacity(performAnimation ? 1 : .zero)
                        Image(systemName: systemName)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: width)
                        Image(systemName: systemName)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: performAnimation ? 0.5 : width)
                            .opacity(performAnimation ? .zero : 1)
                    }
                    
                    .frame(maxHeight: .infinity, alignment: .center)
                }
            }
        }
    }
}

struct ContentView: View {

    @State private var isAnimating = false
    
    var body: some View {
        
        NextTrackButton(performAnimation: $isAnimating)
            .frame(maxWidth: 60)
            .buttonStyle(ButtonAnnimationStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
