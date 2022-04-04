//
//  ContentView.swift
//  Time Fighter
//
//  Created by Philipp on 04.04.22.
//

import SwiftUI
import Combine

extension Timer {
    static var countDownTimer: Publishers.Autoconnect<Timer.TimerPublisher> = {
        Timer.publish(every: countDownInterval, on: .main, in: .common).autoconnect()
    }()
    static let initialCountDown = 3
    static let countDownInterval: TimeInterval = 1
}

struct ContentView: View {

    @State private var score = 0

    @State private var gameStarted = false

    @State private var timeLeft = Timer.initialCountDown
    @State private var timerCancellable: Cancellable?

    @State private var showTimeIsUpAlert = false
    @State private var showInfoAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")

                VStack {
                    HStack {
                        Text("Your score: \(score)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Time Left: \(timeLeft)")
                    }
                    Spacer()
                    Button(action: incrementScore) {
                        Text("Tap Me!")
                            .font(.title3.smallCaps())
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(Color("buttonColor"))
                                    .shadow(radius: 1)
                            )
                    }
                    Spacer()
                }
                .padding()
                .foregroundColor(.black)
                .alert("Time's up!", isPresented: $showTimeIsUpAlert, actions: {
                    Button("OK") {
                        resetGame()
                    }
                }, message: {
                    Text("Your score is \(score)")
                })
                .alert("Time Fighter", isPresented: $showInfoAlert, actions: {
                    Button("Dismiss") { }
                }, message: {
                    Text("Created by The Mighty Swift Developer")
                })
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Text("Time Fighter")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                ToolbarItemGroup {
                    Button {
                        showInfoAlert.toggle()
                    } label: {
                        Label("Info", systemImage: "info.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .background(Color("primaryColor"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
        .onAppear(perform: resetGame)
        .navigationViewStyle(.stack)
    }

    // MARK: Game Logic

    private func resetGame() {
        score = 0
        timeLeft = Timer.initialCountDown
    }

    private func startGame() {
        timerCancellable = Timer.countDownTimer.sink(receiveValue: decrementTimeLeft)
        gameStarted = true
    }

    private func endGame() {
        showTimeIsUpAlert = true
        timerCancellable = nil
        gameStarted = false
    }

    private func incrementScore() {
        if !gameStarted {
            startGame()
        }
        withAnimation {
            score += 1
        }
    }

    private func decrementTimeLeft(x: Timer.TimerPublisher.Output) {
        timeLeft -= 1
        if timeLeft == 0 {
            endGame()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
    }
}
