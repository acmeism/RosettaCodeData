function Send-MorseCode
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string]
        $Message,

        [switch]
        $ShowCode
    )

    Begin
    {
        $morseCode = @{
            a = ".-"   ; b = "-..." ; c = "-.-." ; d = "-.."
            e = "."    ; f = "..-." ; g = "--."  ; h = "...."
            i = ".."   ; j = ".---" ; k = "-.-"  ; l = ".-.."
            m = "--"   ; n = "-."   ; o = "---"  ; p = ".--."
            q = "--.-" ; r = ".-."  ; s = "..."  ; t = "-"
            u = "..-"  ; v = "...-" ; w = ".--"  ; x = "-..-"
            y = "-.--" ; z = "--.." ; 0 = "-----"; 1 = ".----"
            2 = "..---"; 3 = "...--"; 4 = "....-"; 5 = "....."
            6 = "-...."; 7 = "--..."; 8 = "---.."; 9 = "----."
        }
    }
    Process
    {
        foreach ($word in $Message)
        {
            $word.Split(" ",[StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {

                foreach ($char in $_.ToCharArray())
                {
                    if ($char -in $morseCode.Keys)
                    {
                        foreach ($code in ($morseCode."$char").ToCharArray())
                        {
                            if ($code -eq ".") {$duration = 250} else {$duration = 750}

                            [System.Console]::Beep(1000, $duration)
                            Start-Sleep -Milliseconds 50
                        }

                        if ($ShowCode) {Write-Host ("{0,-6}" -f ("{0,6}" -f $morseCode."$char")) -NoNewLine}
                    }
                }

                if ($ShowCode) {Write-Host}
            }

            if ($ShowCode) {Write-Host}
        }
    }
}
