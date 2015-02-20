my @adjacent = gather -> $y, $x {
    take [$y,$x] if abs($x|$y) > 2;
} for -5 .. 5 X -5 .. 5;

solveboard q:to/END/;
    . 0 . . 0 .
    . . . . . .
    0 . 0 1 . 0
    . . . . . .
    . 0 . . 0 .
    END
