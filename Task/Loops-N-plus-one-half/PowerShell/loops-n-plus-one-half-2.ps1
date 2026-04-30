switch (1..10) {
    { $true }     { Write-Host -NoNewLine $_ }
    { $_ -lt 10 } { Write-Host -NoNewLine ", " }
    { $_ -eq 10 } { Write-Host }
}
