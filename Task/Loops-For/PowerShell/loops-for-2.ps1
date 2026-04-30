1..5 | ForEach-Object {
    1..$_ | ForEach-Object {
        Write-Host -NoNewline *
    }
    Write-Host
}
