sub A(Int $m, Int $n) {
    if    $m == 0 { $n + 1 }
    elsif $n == 0 { A($m - 1, 1) }
    else          { A($m - 1, A($m, $n - 1)) }
}
