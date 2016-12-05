if (Get-Process -Name "notepad" -ErrorAction SilentlyContinue)
{
    Write-Warning -Message "notepad is already running."
}
else
{
    Start-Process -FilePath C:\Windows\notepad.exe
}
