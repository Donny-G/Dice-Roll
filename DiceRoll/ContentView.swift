//
//  ContentView.swift
//  DiceRoll
//
//  Created by DeNNiO   G on 23.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var dice = DiceObjectModel()
    
    var body: some View {
        TabView {
            RollDiceView()
                .tabItem {
                    Image(systemName: "cube")
                    Text("Roll the Dice")
                }
            
            ScoreBoardView()
                .tabItem {
                    Image(systemName: "text.badge.star")
                    Text("Scoreboard")
                }
        }
            .environmentObject(dice)
            //!
            .accentColor(.pink)
            .onAppear() {
                UITabBar.appearance().backgroundColor = .yellow
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
