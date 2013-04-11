function Get-Factorial ($x) {
    if ($x -eq 0) {
        return 1
    } else {
        $product = 1
        1..$x | ForEach-Object { $product *= $_ }
        return $product
    }
}
