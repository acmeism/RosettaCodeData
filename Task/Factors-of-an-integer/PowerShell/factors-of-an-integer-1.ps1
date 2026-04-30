function Get-Factor ($a) {
    1..$a | Where-Object { $a % $_ -eq 0 }
}
