function ackermann ([long] $m, [long] $n) {
    if ($m -eq 0) {
        return $n + 1
    }

    if ($n -eq 0) {
        return (ackermann ($m - 1) 1)
    }

    return (ackermann ($m - 1) (ackermann $m ($n - 1)))
}
