function Get-DigitalRoot {
    param($n)
    $ap = 0
    do {$n = Invoke-Expression ("0"+([string]$n -split "" -join "+")+"0"); $ap++} while ($n -ge 10)
    [PSCustomObject]@{
        DigitalRoot = $n
        AdditivePersistence = $ap
    }
}
