GRID_SIZE = 9

def isNumberInRow(board, number, row)
  board[row].includes?(number)
end
def isNumberInColumn(board, number, column)
  board.any?{|row| row[column] == number }
end
def isNumberInBox(board, number, row, column)
  localBoxRow = row - row % 3
  localBoxColumn = column - column % 3
  (localBoxRow...(localBoxRow+3)).each do |i|
    (localBoxColumn...(localBoxColumn+3)).each do |j|
      return true if board[i][j] == number
    end
  end
  false
end

def isValidPlacement(board, number, row, column)
  return !isNumberInRow(board, number, row) &&
  !isNumberInColumn(board, number, column) &&
  !isNumberInBox(board, number, row, column)
end

def solveBoard(board)
  board.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      if(cell == 0)
        (1..GRID_SIZE).each do |n|
          if(isValidPlacement(board,n,i,j))
            board[i][j]=n
            if(solveBoard(board))
              return true
            else
              board[i][j]=0
            end
          end
        end
        return false
      end
    end
  end
  return true
end

def printBoard(board)
  board.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      print cell
      print '|' if j == 2 || j == 5
      print '\n' if j == 8
    end
    print "-"*11 + '\n' if i == 2 || i == 5
  end
  print '\n'
end

board = [
  [7, 0, 2, 0, 5, 0, 6, 0, 0],
  [0, 0, 0, 0, 0, 3, 0, 0, 0],
  [1, 0, 0, 0, 0, 9, 5, 0, 0],
  [8, 0, 0, 0, 0, 0, 0, 9, 0],
  [0, 4, 3, 0, 0, 0, 7, 5, 0],
  [0, 9, 0, 0, 0, 0, 0, 0, 8],
  [0, 0, 9, 7, 0, 0, 0, 0, 5],
  [0, 0, 0, 2, 0, 0, 0, 0, 0],
  [0, 0, 7, 0, 4, 0, 2, 0, 3]]

printBoard(board)
if(solveBoard(board))
  printBoard(board)
end
