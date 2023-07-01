sub infix:<choose> { [*] ($^n ... 0) Z/ 1 .. min($n - $^p, $p) }
