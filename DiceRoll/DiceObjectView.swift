//
//  DiceObjectView.swift
//  DiceRoll
//
//  Created by DeNNiO   G on 23.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct PolygonShape2: Shape {
    var sides: Double
    var scale: Double
    //animation 1
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sides, scale) }
        set { sides = newValue.first
            scale = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        //гипотенуза
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0 * scale
        //центр
        let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        var path = Path()
        let extra: Int = sides != Double(Int(sides)) ? 1 : 0
        var vertex: [CGPoint] = []
        
        for i in 0..<Int(sides) + extra {
            let angle = (Double(i) * (360.0 / sides)) * Double.pi / 180
            //положение вертекса
            let pt = CGPoint(x: center.x + CGFloat(cos(angle) * h), y: center.y + CGFloat(sin(angle) * h))
            vertex.append(pt)
            
            if i == 0 {
                //первый вертекс
                path.move(to: pt)
            } else {
                path.addLine(to: pt)
            }
        }
        path.closeSubpath()
        drawVertexLines(path: &path, vertex: vertex, n: 0)
        return path
    }
    
    func drawVertexLines(path: inout Path, vertex: [CGPoint], n: Int) {
        if (vertex.count - n) < 3 { return }
        for i in (n + 2)..<min(n + (vertex.count - 1), vertex.count) {
            path.move(to: vertex[n])
            path.addLine(to: vertex[i])
        }
        drawVertexLines(path: &path, vertex: vertex, n: n + 1)
    }
}

struct DiceObjectView: View {
    var dicePicsArray = ["dice1", "dice2", "dice3"]
    @EnvironmentObject var dice: DiceObjectModel
    @State private var scale: Double = 1.0
    
    var body: some View {
        ZStack {
            Image(dicePicsArray.randomElement() ?? "dice1")
                .shadow(color: .black, radius: 1, x: 5, y: 5)
            
            PolygonShape2(sides: Double(dice.sides), scale: scale)
                .stroke(LinearGradient(gradient: Gradient(colors: [.orange, .red, .white, .red, .pink]), startPoint: .top, endPoint: .bottom), lineWidth: 3)
                .shadow(color: .black, radius: 1, x: 3, y: 3)
                .animation(.easeIn(duration: 1))
                .padding(20)
        }
    }
}

struct DiceObjectView_Previews: PreviewProvider {
    static var previews: some View {
        DiceObjectView()
    }
}
