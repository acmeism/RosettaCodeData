# with arguments supplied
$ raku -e 'sub MAIN($x, $y) { say $x + $y }' 3 5
8

# missing argument:
$ raku -e 'sub MAIN($x, $y) { say $x + $y }' 3
Usage:
-e '...' x y
