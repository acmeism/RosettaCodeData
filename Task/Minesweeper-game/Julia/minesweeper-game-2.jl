julia> include("minesweeper.jl")

Welcome to Minesweeper

Enter the gridsize x y:
6 4
Found 0 of 5 mines.

     1  2  3  4  5  6
    __________________
 1 | .  .  .  .  .  .
 2 | .  .  .  .  .  .
 3 | .  .  .  .  .  .
 4 | .  .  .  .  .  .

What do you do? ("o x y" to reveal a field; "m x y" to toggle a mine; close)
o 1 1
________________________________________________________________________________

Found 0 of 5 mines.

     1  2  3  4  5  6
    __________________
 1 | 1  .  .  .  .  .
 2 | .  .  .  .  .  .
 3 | .  .  .  .  .  .
 4 | .  .  .  .  .  .

What do you do? ("o x y" to reveal a field; "m x y" to toggle a mine; close)
o 1 2
________________________________________________________________________________

Found 0 of 5 mines.

     1  2  3  4  5  6
    __________________
 1 | 1  .  .  .  .  .
 2 | 2  .  .  .  .  .
 3 | .  .  .  .  .  .
 4 | .  .  .  .  .  .

What do you do? ("o x y" to reveal a field; "m x y" to toggle a mine; close)
o 2 1
________________________________________________________________________________

Found 0 of 5 mines.

     1  2  3  4  5  6
    __________________
 1 | 1  2  .  .  .  .
 2 | 2  .  .  .  .  .
 3 | .  .  .  .  .  .
 4 | .  .  .  .  .  .

What do you do? ("o x y" to reveal a field; "m x y" to toggle a mine; close)
o 6 4
________________________________________________________________________________

Found 0 of 5 mines.

     1  2  3  4  5  6
    __________________
 1 | 1  2  .  .  .  .
 2 | 2  .  2  1  1  1
 3 | .  .  2
 4 | .  .  1

What do you do? ("o x y" to reveal a field; "m x y" to toggle a mine; close)
m 2 2
________________________________________________________________________________

Found 1 of 5 mines.

     1  2  3  4  5  6
    __________________
 1 | 1  2  .  .  .  .
 2 | 2  ?  2  1  1  1
 3 | .  .  2
 4 | .  .  1

What do you do? ("o x y" to reveal a field; "m x y" to toggle a mine; close)
close
ERROR: You closed the game.
