for ($i = 1; $i -le 10; $i++) {
    Write-Host -NoNewLine $i
    if ($i -eq 10) {
        Write-Host
        break
    }
    Write-Host -NoNewLine ", "
}
