$Strings = "Enjoy","Rosetta","Code"

$SB = {param($String)Write-Output $String}

foreach($String in $Strings) {
    Start-Job -ScriptBlock $SB -ArgumentList $String | Out-Null
    }

Get-Job | Wait-Job | Receive-Job
Get-Job | Remove-Job
