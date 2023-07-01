function Get-Product ($a) {
    if ($a.Length -eq 0) {
        return 0
    }
    $s = $a -join '*'
    return (Invoke-Expression $s)
}
