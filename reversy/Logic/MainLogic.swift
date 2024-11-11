import SwiftUI
import Foundation

class MainLogic: ObservableObject {
    var board: [String] = Array(repeating: " ", count: 64)
    @Published var scoreA: Int = 2
    @Published var scoreB: Int = 2
    @Published var aTurn: Bool = true
    @Published var aWinner: Bool? = nil
    @Published var draw: Bool = false
    var quantityOfPossibilities: Int = 0
    
    init() {
        startGame()
    }
    
    func startGame() {
        if board[3+8*4] == " " {
            board[3+8*3] = "A"
            board[4+8*3] = "B"
            board[3+8*4] = "B"
            board[4+8*4] = "A"
        }
    }
    
    func checkBlocking(in index: Int, printColor: Bool) -> Bool{
        var result: Bool = false
        var temp_str: String
        var indexes: [Int?]
        var ans: Bool = false
        var startRow: Int
        var difference: Int
        var startIndex: Int
        var countSteps: Int
        var temp_ind: Int
        var i: Int
        
        // check for vertical
        i = index%8
        temp_str = ""
        for j in stride(from: i, through: 63, by: 8){
            temp_str += board[j]
        }
        indexes = findMatchIndex(inputString: temp_str)
        if indexes[0] != nil {
            if ((indexes[0]!-1)*8 + i == index) || ((indexes[1]!+1)*8 + i == index) {
                indexes.append(i)
                indexes.append(0)
                ans = printCircles(arr: indexes, ind: index, printColor: printColor)
                result = result ? result : ans
            }
        }
        // check for horizontal
        i = index/8
        temp_str = ""
        for j in (i*8...i*8+7){
            temp_str += board[j]
        }
        indexes = findMatchIndex(inputString: temp_str)
        if indexes[0] != nil {
            if (indexes[0]!-1 + i*8 == index) || (indexes[1]!+1 + i*8 == index) {
                indexes.append(i)
                indexes.append(1)
                ans = printCircles(arr: indexes, ind: index, printColor: printColor)
                result = result ? result : ans
            }
        }
        // check for falling diagonals
        if !(index == 7 || index == 56) {
            startRow = max(0, index/8 - index%8)
            difference = index%8 - (index/8 - startRow)
            startIndex = 8*startRow + difference
            countSteps = startIndex/8 == 0 ? 8 - startIndex%8 : 8 - (startIndex%8+startRow)
            temp_str = board[startIndex]
            temp_ind = startIndex
            for _ in 1...countSteps-1 {
                temp_ind += 8 + 1
                temp_str += board[temp_ind]
            }
            indexes = findMatchIndex(inputString: temp_str)
            if indexes[0] != nil {
                if ((indexes[0]!-1)*8 + startIndex + (indexes[0]!-1)) == index || ((indexes[1]!+1)*8 + startIndex + (indexes[1]!+1))  == index {
                    indexes.append(startIndex)
                    indexes.append(2)
                    ans = printCircles(arr: indexes, ind: index, printColor: printColor)
                    result = result ? result : ans
                }
            }
        }
        // check for rising diagonals
        if !(index == 0 || index == 63) {
            startRow = max(0, index/8 - (7 - index%8))
            difference = index%8 + (index/8 - startRow)
            startIndex = 8*startRow + difference
            countSteps = startIndex/8 == 0 ? startIndex%8+1 : (startIndex%8-startRow)+1
            temp_str = board[startIndex]
            temp_ind = startIndex
            for _ in 1...countSteps-1 {
                temp_ind += 8 - 1
                temp_str += board[temp_ind]
            }
            indexes = findMatchIndex(inputString: temp_str)
            if indexes[0] != nil {
                if ((indexes[0]!-1)*8 + startIndex - (indexes[0]!-1)) == index || ((indexes[1]!+1)*8 + startIndex - (indexes[1]!+1))  == index {
                    indexes.append(startIndex)
                    indexes.append(3)
                    ans = printCircles(arr: indexes, ind: index, printColor: printColor)
                    result = result ? result : ans
                }
            }
        }
        
        return result
    }
    
    func findMatchIndex(inputString temp_str: String) -> [Int?] {
        var pattern: String = ""
        if aTurn {
            pattern = "A(B+)A"
        } else {
            pattern = "B(A+)B"
        }
            
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(temp_str.startIndex..., in: temp_str)
            if let match = regex.firstMatch(in: temp_str, options: [], range: range) {
                let lowerBound = match.range.lowerBound
                let upperBound = match.range.upperBound
                return [lowerBound+1, upperBound-2]
            }
        }
        return [nil, nil]
    }
    func makeMove(index: Int, printColor: Bool) -> Bool{
        if board[index] != " " {return false}
        let turn: String = aTurn ? "A" : "B"
        board[index] = turn
        
        let success: Bool = checkBlocking(in: index, printColor: printColor)
        if printColor{
            if success==true {
                aTurn.toggle()
                scoreA = board.count(where: { $0 == "A" })
                scoreB = board.count(where: { $0 == "B" })
                if scoreA==0 {
                    aWinner = false
                } else if scoreB==0 {
                    aWinner = true
                } else {
                    aWinner = nil
                }
                if board.count(where: { $0 == " " }) == 0 {
                    draw = true
                }
            } else {
                board[index] = " "
            }
            return false
        } else {
            board[index] = " "
            if success {
                return true
            } else {
                return false
            }
        }
    }
    
    func printCircles(arr indexes: [Int?], ind index: Int, printColor: Bool) -> Bool{
        let turn: String = aTurn ? "A" : "B"
        if aWinner != nil{
            return false
        } else {
            switch indexes[3]{
            case 0:
                for j in stride(from: indexes[0]!*8+indexes[2]!, through: indexes[1]!*8+indexes[2]!, by: 8){
                    if printColor{
                        board[j] = turn
                    }
                }
            case 1:
                for j in ((indexes[2]!*8+indexes[0]!)...(indexes[2]!*8+indexes[1]!)){
                    if printColor{
                        board[j] = turn
                    }
                }
            case 2:
                let temp_ind = indexes[2]!
                for i in indexes[0]!...indexes[1]! {
                    if printColor {
                        board[temp_ind + i*8 + i] = turn
                    }
                }
            case 3:
                let temp_ind = indexes[2]!
                for i in indexes[0]!...indexes[1]! {
                    if printColor {
                        board[temp_ind + i*8 - i] = turn
                    }
                }
            default: return false
            }
            return true
        }
    }
    
    func resetGame() {
        board = Array(repeating: " ", count: 64)
        scoreA = 2
        scoreB = 2
        aWinner = nil
        aTurn = true
        startGame()
    }
}
