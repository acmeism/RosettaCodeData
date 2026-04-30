function mean ($x) {
    if ($x.Count -eq 0) {
        return 0
    } else {
        $sum = 0
        foreach ($i in $x) {
            $sum += $i
        }
        return $sum / $x.Count
    }
}
