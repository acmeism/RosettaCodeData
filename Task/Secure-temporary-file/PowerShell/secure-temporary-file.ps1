$tempFile = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFile -Value "FileName = $tempFile"
Get-Content -Path $tempFile
Remove-Item -Path $tempFile
