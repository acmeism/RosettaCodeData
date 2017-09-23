/// @Author: Alexandre Felipe (o.alexandre.felipe@gmail.com)
/// @Date:  2017-May-10
///


//////////////////////////////////////////////////////////////////////////////
///  NumbrixSolver                                                         ///
///     Solve the puzzle, by using system verilog randomization engine     ///
//////////////////////////////////////////////////////////////////////////////
class NumbrixSolver;
  rand int solvedBoard[][];
  int fixedBoard[][];
  int numCells;
  ////////////////////////////////////////////////////////////////////////////
  /// Dynamically resize the board accordingly to the size of the reference///
  /// board                                                                ///
  ////////////////////////////////////////////////////////////////////////////
  constraint height {
    solvedBoard.size == fixedBoard.size;
  }
  constraint width {
    foreach(solvedBoard[i]) solvedBoard[i].size == fixedBoard[i].size;
  }

  ////////////////////////////////////////////////////////////////////////////
  ///  Fix the positions defined in the input board                        ///
  ////////////////////////////////////////////////////////////////////////////
  constraint fixed {
    foreach(solvedBoard[i]) foreach(solvedBoard[i][j])
      if(fixedBoard[i][j] != 0)solvedBoard[i][j] == fixedBoard[i][j];
  }
  ////////////////////////////////////////////////////////////////////////////
  ///  Ensures that the whole board is filled from the number with numbers ///
  ///   1,2,3,...,numCells                                                 ///
  ////////////////////////////////////////////////////////////////////////////
  constraint range {
    foreach(solvedBoard[i])foreach(solvedBoard[i][j])
      solvedBoard[i][j] inside {[1:numCells]};
  }
  ////////////////////////////////////////////////////////////////////////////
  ///  Ensures that there is no repeated number, consequently every number ///
  ///  is present on the board                                             ///
  ////////////////////////////////////////////////////////////////////////////
  constraint uniqueness {
    foreach(solvedBoard[i1]) foreach(solvedBoard[i1][j1])
    foreach(solvedBoard[i2]) foreach(solvedBoard[i2][j2])
      if((i1 != i2) || (j1 != j2)) solvedBoard[i1][j1] != solvedBoard[i2][j2];
  }

  ////////////////////////////////////////////////////////////////////////////
  /// Ensures that exists one direction connecting the numbers in          ///
  /// increasing order                                                     ///
  ////////////////////////////////////////////////////////////////////////////
  constraint f_seq {
    foreach(solvedBoard[i])foreach(solvedBoard[i][j])
      (solvedBoard[i][j] == (numCells)) ||
      (solvedBoard[(i < solvedBoard.size-1) ? (i+1): i][j]    ==
                                         solvedBoard[i][j]+1) ||
      (solvedBoard[i][(j < solvedBoard[i].size - 1) ? j+1: j] ==
                                         solvedBoard[i][j]+1) ||
      (solvedBoard[(i > 0) ? i-1: i][j]                       ==
                                         solvedBoard[i][j]+1) ||
      (solvedBoard[i][(j > 0)? j-1:j]                         ==
                                         solvedBoard[i][j]+1);
  }


  function void pre_randomize();
    // the multiplication is not supported in the constraints
    numCells = fixedBoard.size * fixedBoard[0].size;
  endfunction
  function void printSolvedBoard();
    foreach(solvedBoard[i]) begin
      foreach(solvedBoard[j]) begin
        $write("%4d", solvedBoard[i][j]);
      end
      $display("");
    end
  endfunction
endclass


//////////////////////////////////////////////////////////////////////////////
/// SolveNumBrix: A program demonstrating how to use NumbrixSolver class   ///
//////////////////////////////////////////////////////////////////////////////

program SolveNumbrix;
  NumbrixSolver board;
  initial begin
    board = new;
    board.fixedBoard = '{
      '{0,  0,  0,  0,  0,  0,  0,  0,  0},
      '{0,  0, 46, 45,  0, 55, 74,  0,  0},
      '{0, 38,  0,  0, 43,  0,  0, 78,  0},
      '{0, 35,  0,  0,  0,  0,  0, 71,  0},
      '{0,  0, 33,  0,  0,  0, 59,  0,  0},
      '{0, 17,  0,  0,  0,  0,  0, 67,  0},
      '{0, 18,  0,  0, 11,  0,  0, 64,  0},
      '{0,  0, 24, 21,  0,  1,  2,  0,  0},
      '{0,  0,  0,  0,  0,  0,  0,  0,  0}};
    if(board.randomize()) begin
      $display("Solution for the Example 1");
      board.printSolvedBoard();
    end
    else begin
      $display("Failed to solve Example 1");
    end

    board.fixedBoard = '{
       {0,  0,  0,  0,  0,  0,  0,  0,  0},
       {0, 11, 12, 15, 18, 21, 62, 61,  0},
       {0,  6,  0,  0,  0,  0,  0, 60,  0},
       {0, 33,  0,  0,  0,  0,  0, 57,  0},
       {0, 32,  0,  0,  0,  0,  0, 56,  0},
       {0, 37,  0,  1,  0,  0,  0, 73,  0},
       {0, 38,  0,  0,  0,  0,  0, 72,  0},
       {0, 43, 44, 47, 48, 51, 76, 77,  0},
      '{0,  0,  0,  0,  0,  0,  0,  0,  0}};

    if(board.randomize()) begin
      $display("Solution for the Example 2");
      board.printSolvedBoard();
    end
    else begin
      $display("Failed to solve Example 2");
    end
    $finish;
  end
endprogram
