function Get-Bell
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [ValidateRange(1,12)]
        [int]
        $Hour,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [ValidateSet(0,30)]
        [int]
        $Minute
    )

    $bells = @{
        OneBell    =          1
        TwoBells   =          2
        ThreeBells =       2, 1
        FourBells  =       2, 2
        FiveBells  =    2, 2, 1
        SixBells   =    2, 2, 2
        SevenBells = 2, 2, 2, 1
        EightBells = 2, 2, 2, 2
    }

    filter Invoke-Bell
    {
        if ($_ -eq 1)
        {
            [System.Media.SystemSounds]::Asterisk.Play()
            Write-Host -NoNewline "♪"
        }
        else
        {
            [System.Media.SystemSounds]::Exclamation.Play()
            Write-Host -NoNewline "♪♪  "
        }

        Start-Sleep -Milliseconds 500
    }


    $time = New-TimeSpan -Hours $Hour -Minutes $Minute

    switch ($time.Hours)
    {
         1 {if ($time.Minutes -eq 0) {$bells.TwoBells   | Invoke-Bell} else {$bells.ThreeBells | Invoke-Bell}; break}
         2 {if ($time.Minutes -eq 0) {$bells.FourBells  | Invoke-Bell} else {$bells.FiveBells  | Invoke-Bell}; break}
         3 {if ($time.Minutes -eq 0) {$bells.SixBells   | Invoke-Bell} else {$bells.SevenBells | Invoke-Bell}; break}
         4 {if ($time.Minutes -eq 0) {$bells.EightBells | Invoke-Bell} else {$bells.OneBell    | Invoke-Bell}; break}
         5 {if ($time.Minutes -eq 0) {$bells.TwoBells   | Invoke-Bell} else {$bells.ThreeBells | Invoke-Bell}; break}
         6 {if ($time.Minutes -eq 0) {$bells.FourBells  | Invoke-Bell} else {$bells.FiveBells  | Invoke-Bell}; break}
         7 {if ($time.Minutes -eq 0) {$bells.SixBells   | Invoke-Bell} else {$bells.SevenBells | Invoke-Bell}; break}
         8 {if ($time.Minutes -eq 0) {$bells.EightBells | Invoke-Bell} else {$bells.OneBell    | Invoke-Bell}; break}
         9 {if ($time.Minutes -eq 0) {$bells.TwoBells   | Invoke-Bell} else {$bells.ThreeBells | Invoke-Bell}; break}
        10 {if ($time.Minutes -eq 0) {$bells.FourBells  | Invoke-Bell} else {$bells.FiveBells  | Invoke-Bell}; break}
        11 {if ($time.Minutes -eq 0) {$bells.SixBells   | Invoke-Bell} else {$bells.SevenBells | Invoke-Bell}; break}
        12 {if ($time.Minutes -eq 0) {$bells.EightBells | Invoke-Bell} else {$bells.OneBell    | Invoke-Bell}}
    }

    Write-Host
}

Write-Host "Time Bells`n---- -----`n"

1..12 | ForEach-Object {

    $date = Get-Date -Hour $_ -Minute  0
    Write-Host -NoNewline "$($date.ToString("hh:mm")) "
    Get-Bell -Hour $_ -Minute  0

    $date = $date.AddMinutes(30)
    Write-Host -NoNewline "$($date.ToString("hh:mm")) "
    Get-Bell -Hour $_ -Minute 30
}
