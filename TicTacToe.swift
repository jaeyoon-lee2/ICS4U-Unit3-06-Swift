/*
Tic Tac Toe (X's and O's) program.
author  Jay Lee
version 1.0
since   2020-05-16
*/
import Foundation

enum InvalidInputError : Error {
  case invalidInput
}

// This function calculates the best next move for computer based on current board using minimax function.
func CompNextMove(currentBoard: [String]) -> Int {
  var newBoard = currentBoard
  var bestScore = Int.min
  var goodMove = -1

  if (IsNumeric(strNum: newBoard[4])) {
    return 4
  } else {
    for index in 0..<newBoard.count {
      if (IsNumeric(strNum: newBoard[index])) {
        newBoard[index] = "O"
        let score = Minimax(board: newBoard, isMaximizing: false)
        newBoard[index] = String(index + 1)
        if (score > bestScore) {
          bestScore = score
          goodMove = index
        }
      }
    }
  }
  return goodMove
}

func Minimax(board: [String], isMaximizing: Bool) -> Int {
  var board = board
  // evaluation
  if (WinOrLost(board: board, takenSpace: "O")) {
    return 1
  } else if (WinOrLost(board: board, takenSpace: "X")) {
    return -1
  } else if (IsFull(presentBoard: board)) {
    return 0
  }
  var player: String
  var bestScore: Int
  if (isMaximizing) {
    bestScore = Int.min
    player = "O"
  } else {
    bestScore = Int.max
    player = "X"
  }
  for index in 0..<board.count {
    if (IsNumeric(strNum: board[index])) {
      board[index] = player
      let score = Minimax(board: board, isMaximizing: !isMaximizing)
      board[index] = String(index + 1)
      if (isMaximizing) {
        bestScore = max(score, bestScore)
      } else {
        bestScore = min(score, bestScore)
      }
    }
  }
  return bestScore
}

// This function returns true or false for whether or not inputted array is a magic square.
func WinOrLost(board: [String], takenSpace: String) -> Bool {
  return (board[0] == takenSpace && board[1] == takenSpace
                                       && board[2] == takenSpace)
            || (board[3] == takenSpace && board[4] == takenSpace
                                       && board[5] == takenSpace)
            || (board[6] == takenSpace && board[7] == takenSpace
                                       && board[8] == takenSpace)
            || (board[0] == takenSpace && board[3] == takenSpace
                                       && board[6] == takenSpace)
            || (board[1] == takenSpace && board[4] == takenSpace
                                       && board[7] == takenSpace)
            || (board[2] == takenSpace && board[5] == takenSpace
                                       && board[8] == takenSpace)
            || (board[0] == takenSpace && board[4] == takenSpace
                                       && board[8] == takenSpace)
            || (board[2] == takenSpace && board[4] == takenSpace
                                       && board[6] == takenSpace)
}

// This function returns whether board is full or not.
func IsFull(presentBoard: [String]) -> Bool {
  var full = true
  for counter in 0..<presentBoard.count {
    if (IsNumeric(strNum: presentBoard[counter])) {
      full = false
      break
    }
  }
  return full
}

// This function prints current game state.
func PrintBoard(theBoard: [String]) {
  print("\n----+----+----")
  for index in 0..<theBoard.count {
    if (index % 3 - 2 == 0) {
      print("| \(theBoard[index]) |")
      print("----+----+----")
    } else {
      print("| \(theBoard[index]) ", terminator:"")
    }
  }
}

// This function checks the string is numeric.
func IsNumeric(strNum: String) -> Bool {
  if (Int(strNum) == nil) {
    return false
  } else {
    return true
  }
}

// main stub
print("Welcome to tic tac toe!")
var board: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
var boardFull = false
repeat {
  do {
    PrintBoard(theBoard: board)
    print("\nWhich space would you like to the X?", terminator: " ")
    guard let space = Int(readLine()!) else {
      throw InvalidInputError.invalidInput
    }
    if (space > board.count  || space < 1) {
      print("That spot is invalid!")
    } else if (board[space - 1] == "O" || board[space - 1] == "X") {
      print("That spot's taken!")
    } else if (IsNumeric(strNum: board[space - 1])) {
      board[space - 1] = "X"
      if (!IsFull(presentBoard: board)) {
        let goodComputerMove = CompNextMove(currentBoard: board)
        board[goodComputerMove] = "O"
      } else {
        PrintBoard(theBoard: board)
        print("\nTie.")
      }
    } else {
      print("Error")
    }
    if (WinOrLost(board: board, takenSpace: "X")) {
      PrintBoard(theBoard: board)
      print("\nX has won.")
      break
    } else if (WinOrLost(board: board, takenSpace: "O")) {
      PrintBoard(theBoard: board)
      print("\nO has won.")
      break
    }
    boardFull = IsFull(presentBoard: board)
  } catch {
    print("Error")
  }
} while !boardFull

print("\nGame Over.")
