try
{
    Get-Content -Path .\temp.txt
}
catch [System.IO.FileNotFoundException]
{
    Write-Host "File not found exception"
}
catch [System.Exception]
{
    Write-Host "Other exception"
}
