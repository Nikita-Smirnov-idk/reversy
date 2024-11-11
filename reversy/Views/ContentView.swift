//
//  ContentView.swift
//  reversy
//
//  Created by Никита Смирнов on 02.11.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainLogic: MainLogic
    
    var body: some View {
        GeometryReader{ proxy in
            VStack {
                var buttonText: String {
                    if mainLogic.aWinner == true {
                        return "Зеленые выиграли"
                    } else if mainLogic.aWinner == false {
                        return "Красные выиграли"
                    } else if mainLogic.draw {
                        return "Ничья"
                    } else {
                        return ""
                    }
                }
                if buttonText.count > 0 {
                    Button {
                        // Действие при нажатии на кнопку
                    } label: {
                        Text(buttonText) // Переменная с текстом кнопки
                            .foregroundStyle(Color.white)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .font(.largeTitle)
                    }
                }
                ZStack {
                    Text("Ходит:")
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .foregroundStyle(Color.white)
                        .font(.largeTitle)
                        .background(mainLogic.aTurn ? Color.green : Color.red)
                        .cornerRadius(10)
                }
                HStack {
                    Button(String(mainLogic.scoreA)){
                    }
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .foregroundStyle(Color.white)
                    .background(colorForBoardValue(value: "A", index: 0))
                    .cornerRadius(5)
                    .font(.largeTitle)
                    Button(String(mainLogic.scoreB)){
                    }
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .foregroundStyle(Color.white)
                    .background(colorForBoardValue(value: "B", index: 0))
                    .cornerRadius(5)
                    .font(.largeTitle)
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 10) {
                    ForEach(0..<8 * 8, id: \.self) { index in
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                            
                            Circle()
                                .fill(colorForBoardValue(value: mainLogic.board[index], index: index))
                        }
                        .onTapGesture {
                            var _ = mainLogic.makeMove(index: index, printColor: true)
                        }
                    }
                }
                .padding()
                Button("Начать заново"){
                    mainLogic.resetGame()
                }
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .foregroundStyle(Color.white)
                .background(Color.blue)
                .cornerRadius(5)
                .font(.largeTitle)
            }
            .padding()
            .background(Color.white)
        }
        .onChange(of: mainLogic.aTurn) {
            resetQuantity()
        }
    }
    
    private func colorForBoardValue(value: String, index: Int) -> Color {
        switch value {
        case "A":
            return Color.green
        case "B":
            return Color.red
        default:
            let ans = mainLogic.makeMove(index: index, printColor: false)
            if !ans {
                return Color.black.opacity(0.1)
            } else {
                mainLogic.quantityOfPossibilities += 1
                switch mainLogic.aTurn{
                case true:
                    return Color.green.opacity(0.3)
                case false:
                    return Color.red.opacity(0.3)
                }
            }
        }
    }
    
    private func resetQuantity() {
        if mainLogic.quantityOfPossibilities==0{
            if mainLogic.scoreA>mainLogic.scoreB{
                mainLogic.aWinner = true
            } else if mainLogic.scoreA==mainLogic.scoreB{
                mainLogic.draw = true
            } else {
                mainLogic.aWinner = false
            }
        } else {
            mainLogic.quantityOfPossibilities = 0
        }
    }
}
