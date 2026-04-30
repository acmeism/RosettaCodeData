foreach ($m in 0..3) {
    foreach ($n in 0..6) {
        Write-Host -NoNewline ("{0,5}" -f (ackermann $m $n))
    }
    Write-Host
}
