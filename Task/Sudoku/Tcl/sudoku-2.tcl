SudokuSolver create sudoku
sudoku load {
    {3 9 4    @ @ 2    6 7 @}
    {@ @ @    3 @ @    4 @ @}
    {5 @ @    6 9 @    @ 2 @}

    {@ 4 5    @ @ @    9 @ @}
    {6 @ @    @ @ @    @ @ 7}
    {@ @ 7    @ @ @    5 8 @}

    {@ 1 @    @ 6 7    @ @ 8}
    {@ @ 9    @ @ 8    @ @ @}
    {@ 2 6    4 @ @    7 3 5}
}
sudoku solve
# Simple pretty-printer for completed sudokus
puts +-----+-----+-----+
foreach line [sudoku dump] postline {0 0 1 0 0 1 0 0 1} {
    puts |[lrange $line 0 2]|[lrange $line 3 5]|[lrange $line 6 8]|
    if {$postline} {
	puts +-----+-----+-----+
    }
}
sudoku destroy
