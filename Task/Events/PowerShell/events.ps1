$timer = New-Object -TypeName System.Timers.Timer -Property @{Enabled=$true; Interval=1000; AutoReset=$true}

$action = {
    $global:counter += 1
    Write-Host “Event counter is ${counter}: $((Get-Date).ToString("hh:mm:ss"))”
    if ($counter -ge $event.MessageData)
    {
        Write-Host “Timer stopped”
        $timer.Stop()
    }
}

$job = Register-ObjectEvent -InputObject $timer -MessageData 5 -SourceIdentifier Count -EventName Elapsed -Action $action

$global:counter = 0
& $job.Module {$global:counter}
