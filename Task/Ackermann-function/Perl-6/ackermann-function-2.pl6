multi sub A(0,      Int $n) { $n + 1                   }
multi sub A(Int $m, 0     ) { A($m - 1, 1)             }
multi sub A(Int $m, Int $n) { A($m - 1, A($m, $n - 1)) }
