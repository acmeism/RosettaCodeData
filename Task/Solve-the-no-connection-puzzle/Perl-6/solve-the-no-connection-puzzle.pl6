my @adjacent = gather -> $y, $x {
    take [$y,$x] if abs($x|$y) > 2;
} for flat -5 .. 5 X -5 .. 5;

solveboard q:to/END/;
    . _ . . _ .
    . . . . . .
    _ . _ 1 . _
    . . . . . .
    . _ . . _ .
    END
