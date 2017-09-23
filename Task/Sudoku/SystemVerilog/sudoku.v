/// @Author: Alexandre Felipe (o.alexandre.felipe@gmail.com)
/// @Date: 2017-May-10
///

//////////////////////////////////////////////////////////////////////////////
/// SudokuSolver                                                           ///
///    A class that fills up a sudoku board, the initial board is given    ///
///    as an array preset_rows, the positions where preset_rows is zero    ///
///    are to be determined. Three views of the sudoku board are created   ///
///    and the uniqueness of its elements are defined by on constraint for ///
///    each view, one constraint ensures that the values are between 1 and ///
///    9, and two other constraints are used to ensure that the values in  ///
///    all three views agree to each other.                                ///
///                                                                        ///
///                                                                        ///
///    A solution using only the "rows" array would be possible, however   ///
///    this illustrates better how one can relate different variables in   ///
///    SystemVerilog Constrained randomization.                            ///
//////////////////////////////////////////////////////////////////////////////
class SudokuSolver;
  rand int tiles[0:8][0:8];
  rand int rows[0:8][0:8];
  rand int cols[0:8][0:8];
  int preset_rows[0:8][0:8];
  constraint board_input {
    foreach(preset_rows[i])foreach(preset_rows[i][j])
       if(preset_rows[i][j] != 0) rows[i][j] == preset_rows[i][j];
  }
  constraint range {
    foreach(rows[i]) foreach(rows[i][j])
        rows[i][j] inside {[1:9]};
  }
  ////////////////////////////////////////////////
  /// Every number in a row is unique          ///
  ////////////////////////////////////////////////
  constraint rows_permutation {
    foreach(rows[i]) foreach(rows[i][j1])
                     foreach(rows[i][j2])
      if(j1 != j2) rows[i][j1] != rows[i][j2];
  }
  ///////////////////////////////////////////////
  /// Every number in a column is unique      ///
  ///////////////////////////////////////////////
  constraint cols_permutation {
    foreach(cols[i]) foreach(cols[i][j1])
                     foreach(cols[i][j2])
      if(j1 != j2) cols[i][j1] != cols[i][j2];
  }
  /////////////////////////////////////////////////
  /// Every number in a tile (square) is unique ///
  /////////////////////////////////////////////////
  constraint tiles_permutation {
    foreach(tiles[i]) foreach(tiles[i][j1])
                     foreach(tiles[i][j2])
      if(j1 != j2) tiles[i][j1] != tiles[i][j2];
  }
  ///////////////////////////////////////////////////
  /// Makes sure that sure that the numbers in    ///
  /// each view agree with other views            ///
  ///////////////////////////////////////////////////
  constraint rows_vs_tiles {
    foreach(tiles[i]) foreach(tiles[i][j])
      tiles[i][j] == rows[(i/3) * 3 + (j/3)][3*(i%3)+(j%3)];
  }
  constraint rows_vs_cols {
    foreach(cols[i]) foreach(cols[i][j])
      cols[i][j] == rows[j][i];
  }
  ///////////////////////////////////////////////////
  /// Print the current state of the board in the ///
  /// standard output                             ///
  ///////////////////////////////////////////////////
  function void printBoard;
    int i, j;
    for(i = 0; i < 9; ++i) begin
      if(i % 3 == 0)$display("   -------------");
      $write("   ");
      for(j = 0; j < 9; ++j) begin
        if(j % 3 == 0) $write("|");
        $write("%c", "0" + rows[i][j]);
      end
      $display("|");
    end
    $display("   -------------");
  endfunction
  function void printInitial;
    int i, j;
    for(i = 0; i < 9; ++i) begin
      if(i % 3 == 0)$display("-------------");
      for(j = 0; j < 9; ++j) begin
        if(j % 3 == 0) $write("|");
        if(preset_rows[i][j]) begin
          $write("%c", "0" + preset_rows[i][j]);
        end
        else begin
          $write(".");
        end
      end
      $display("|");
    end
    $display("-------------");
  endfunction

endclass

//////////////////////////////////////////////////////
/// Simple program instantiating the sudoku object ///
//////////////////////////////////////////////////////
program SudokuTest;
  SudokuSolver board;
initial begin
  board = new;
  foreach(board.preset_rows[0][i]) board.preset_rows[i][i] = i+1;
  $display("Initial Board:");
  board.printInitial();
  // Generate two different solutions for the board
  if(board.randomize())begin
    $display("One solution:");
    board.printBoard();
  end
  else begin
    $display("ERROR: Failed to generate first solution");
  end
  if(board.randomize())begin
    $display("Another solution:");
    board.printBoard();
  end
  else begin
    $display("ERROR: Failed to generate second solution");
  end
end
endprogram
