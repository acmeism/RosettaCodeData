# with arguments supplied
$ perl6 -e 'sub MAIN($x, $y) { say $x + $y }' 3 5
8

# missing argument:
$ perl6 -e 'sub MAIN($x, $y) { say $x + $y }' 3
Usage:
-e '...' x y
