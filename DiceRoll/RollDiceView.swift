//
//  RollDiceView.swift
//  DiceRoll
//
//  Created by DeNNiO   G on 23.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import CoreHaptics


struct RollDiceView: View {
    @EnvironmentObject var dice: DiceObjectModel
    @Environment(\.managedObjectContext) var moc
    
    @State private var name = ""
    @State private var randomNumber = 0
    @State private var counter = 0
    @State private var timerOn = false
    
    @State private var rotationAnimationAmount = 0.0
    let sidesArray = [3, 4, 6, 8, 10]
    let dice3Side = [0, 3, 6, 8]
    let dice4Side = [0, 2, 5, 6, 8, 10]
    let dice6Side = [0, 2, 5, 6, 8, 10, 12, 14]
    let dice8Side = [0, 2, 5, 6, 8, 10, 12, 14, 16, 18]
    let dice10Side = [0, 2, 5, 6, 8, 10, 12, 14, 16, 18, 20, 22]
    
   
    
    @State private var randomNumberByType = 0

    @State private var engine: CHHapticEngine?
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating\(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        //check for support
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        var events = [CHHapticEvent]()
        //config haptic
        for i in stride(from: 0, to: 1, by: 0.1 ) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 - i)
            events.append(event)
        }
        //convert into pattern and play
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("failed to play pattern\(error.localizedDescription)")
        }
    }
        
     func rotateDice() {
        timerOn = true
     }
    
    func saveTo() {
        let newPersonalScore = Result(context: moc)
        newPersonalScore.id = UUID()
        newPersonalScore.name = self.name
        newPersonalScore.score = Int16(self.randomNumber)
        newPersonalScore.type = Int16(dice.sides)
        try? self.moc.save()
        
        
    }
     
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.red, .yellow, .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Section(header: Text("Player name")) {
                        TextField("Enter player name", text: $name)
                            .frame(width: 350, height: 100)
                            .background(Color.orange)
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 1, x: 5, y: 5)
                    }
                        .font(.system(size: 20, weight: Font.Weight.black, design: Font.Design.rounded))
                    
                    Section(header: Text("Choose dice type")) {
                        Picker("Choose dice type", selection: $dice.sides) {
                            ForEach(sidesArray, id: \.self) {number in
                                Text("\(number)")
                            }
                        }
                            .pickerStyle(SegmentedPickerStyle())
                            .colorMultiply(.yellow)
                            .background(Color.orange)
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 1, x: 5, y: 5)
                    }
                        .font(.system(size: 20, weight: Font.Weight.black, design: Font.Design.rounded))
            
                    ZStack {
                        DiceObjectView()
                            .onTapGesture {
                                self.rotateDice()
                            }
                            .animation(.easeInOut(duration: 2))
                            .rotation3DEffect(.degrees(rotationAnimationAmount), axis: (x: 1, y: 1, z: 1))
            
                        Text("\(randomNumber)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .offset(x: -50, y: -50)
                    }
                }
            }
                .onAppear(perform: prepareHaptics)
                .navigationBarTitle("Roll Initiative", displayMode: .automatic)
        
        }.onReceive(timer) { time in
            guard self.timerOn else { return}
            if self.counter == 5 {
                self.counter = 0
                self.timerOn = false
                self.saveTo()
                self.name = ""
            } else {
                self.complexSuccess()
                switch self.dice.sides {
                case 3:
                    self.randomNumber = self.dice3Side.randomElement() ?? 0
                    print(self.dice3Side)
                case 4:
                    self.randomNumber = self.dice4Side.randomElement() ?? 0
                    print(self.dice4Side)
                case 6:
                    self.randomNumber = self.dice6Side.randomElement() ?? 0
                    print(self.dice6Side)
                case 8:
                    self.randomNumber = self.dice8Side.randomElement() ?? 0
                    print(self.dice8Side)
                case 10:
                    self.randomNumber = self.dice10Side.randomElement() ?? 0
                    print(self.dice10Side)
                default:
                    self.randomNumber = 0
                    print("0")
                }
                    withAnimation { self.rotationAnimationAmount += 360}
            }
               self.counter += 1
       }
           .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.timerOn = false
            }
           .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                self.timerOn = true
            }
    }
}

struct RollDiceView_Previews: PreviewProvider {
    static var previews: some View {
        RollDiceView()
    }
}
