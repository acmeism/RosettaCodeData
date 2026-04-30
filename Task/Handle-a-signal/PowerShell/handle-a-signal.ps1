$Start_Time = (Get-date).second
Write-Host "Type CTRL-C to Terminate..."
$n = 1
Try
{
    While($true)
    {
        Write-Host $n
        $n ++
        Start-Sleep -m 500
    }
}
Finally
{
    $End_Time = (Get-date).second
    $Time_Diff = $End_Time - $Start_Time
    Write-Host "Total time in seconds"$Time_Diff
}
