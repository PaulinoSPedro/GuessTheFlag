//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by pedro.paulino on 04/11/25.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .shadow(radius: 5)
    }
}

struct FlagImage: View {
    var imageName: String
    var body: some View {
        Image(imageName)
            .clipShape(.buttonBorder)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var alertMessage = ""
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    
    @State private var score: Int = 0
    @State private var roundNumber: Int = 1
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 72/255, green: 184/255, blue: 208/255), location: 0.3),
                .init(color: Color(red: 138/255, green: 225/255, blue: 252/255), location: 0.4)
            ], center: .top, startRadius: 400, endRadius: 600)
            
            .ignoresSafeArea(edges: .all)
            
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .titleStyle()
             
                
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.headline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                       
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        
        }message: {
            Text(alertMessage)
            Text("Your score is \(score)")
        }
        
        .alert(scoreTitle, isPresented: $gameOver){
            Button("Play Again", action: askQuestion)
        }message: {
            Text(alertMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            alertMessage = "You got it!"
            score += 1
        }else{
            scoreTitle = "Wrong"
            alertMessage = "That's the flag of \(countries[correctAnswer])"
            score -= (score > 0) ? 1 : 0
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        print("Ask question \(roundNumber)")
        if roundNumber == 8 {
            scoreTitle = "Game Over"
            gameOver = true
            showingScore = false
            alertMessage = "Final score: \(score)"
            score = 0
            roundNumber = 1
            return
            
        }
        roundNumber += 1
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}

#Preview {
    ContentView()
}
