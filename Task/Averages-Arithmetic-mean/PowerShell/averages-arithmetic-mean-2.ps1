function mean ($x) {
    if ($x.Count -eq 0) {
        return 0
    } else {
        return ($x | Measure-Object -Average).Average
    }
}
