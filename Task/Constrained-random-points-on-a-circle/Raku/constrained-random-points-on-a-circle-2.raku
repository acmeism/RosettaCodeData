(say ~.map: { $_ // ' ' } for my @matrix) given do
    -> [$x, $y] { @matrix[$x][$y] = '*' } for pick 100, do
        for ^32 X ^32 -> ($x, $y) {
            [$x,$y] when 100..225 given [+] ($x,$y X- 15) X** 2;
        }
