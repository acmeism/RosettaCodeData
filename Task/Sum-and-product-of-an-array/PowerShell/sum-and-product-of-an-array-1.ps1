function Get-Sum ($a) {
    return ($a | Measure-Object -Sum).Sum
}
