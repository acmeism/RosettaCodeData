function Get-Factor ($a) {
    1..[Math]::Sqrt($a) `
        | Where-Object { $a % $_ -eq 0 } `
        | ForEach-Object { $_; $a / $_ } `
        | Sort-Object -Unique
}
