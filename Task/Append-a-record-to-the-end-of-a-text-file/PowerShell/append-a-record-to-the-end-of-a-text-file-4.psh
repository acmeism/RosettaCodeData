if (-not(Test-FileLock -Path ".\passwd.txt"))
{
    $records | Export-File -Path ".\passwd.txt"
}
