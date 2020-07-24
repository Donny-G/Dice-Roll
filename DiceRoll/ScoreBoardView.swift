//
//  ScoreBoardView.swift
//  DiceRoll
//
//  Created by DeNNiO   G on 23.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?
    var titleColor: UIColor?

    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                GeometryReader { geometry in
                Color(self.backgroundColor ?? .clear)
                    .frame(height: geometry.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.top)
                Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }
}

struct ScoreBoardView: View {
    @FetchRequest(entity: Result.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Result.score, ascending: false)]) var results: FetchedResults<Result>
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.red, .yellow, .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                Group {
                    ScrollView {
                        ForEach(results, id: \.id) { result in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Player: \(result.wrappedName)")
                                    Text("Result: \(result.score)")
                                }
                                    .font(.system(size: 20, weight: Font.Weight.black, design: Font.Design.rounded))
                                
                            Spacer()
                                
                                Image("\(result.type)")
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .shadow(radius: 1, x: 3, y: 3)
                           
                            }
                        }
                    }
                }
            }
                .navigationBarTitle("Scoreboard", displayMode: .inline)
                .navigationBarColor(backgroundColor: .init(red: 0.996, green: 0.337, blue: 0.153, alpha: 1.0), titleColor: .black)
        }
    }
}

struct ScoreBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoardView()
    }
}
