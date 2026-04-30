function Get-Soundex
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]
        $InputObject
    )

    Begin
    {
        $characterGroup = [PSCustomObject]@{
            1 = @('B','F','P','V')
            2 = @('C','G','J','K','Q','S','X','Z')
            3 = @('D','T')
            4 = @('L')
            5 = @('M','N')
            6 = @('R')
        }

        function ConvertTo-SoundexDigit ([char]$Character)
        {
            switch ($Character)
            {
                {$_ -in $characterGroup.1} {return 1}
                {$_ -in $characterGroup.2} {return 2}
                {$_ -in $characterGroup.3} {return 3}
                {$_ -in $characterGroup.4} {return 4}
                {$_ -in $characterGroup.5} {return 5}
                {$_ -in $characterGroup.6} {return 6}
                Default                    {return 0}
            }
        }
    }
    Process
    {
        foreach ($String in $InputObject)
        {
            $originalString = $String
            $String = $String.ToUpper()
            $isHorWcharacter = $false
            $soundex = New-Object -TypeName System.Text.StringBuilder

            $soundex.Append($String[0]) | Out-Null

            for ($i = 1; $i -lt $String.Length; $i++)
            {
                $currentCharacterDigit = ConvertTo-SoundexDigit $String[$i]

                if ($currentCharacterDigit -ne 0)
                {
                    if ($i -eq (ConvertTo-SoundexDigit $String[$i-1]))
                    {
                        continue
                    }

                    if (($i -gt 2) -and ($isHorWcharacter) -and ($currentCharacterDigit -eq (ConvertTo-SoundexDigit $String[$i-2])))
                    {
                        continue
                    }

                    $soundex.Append($currentCharacterDigit) | Out-Null
                }

                $isHorWcharacter = $String[$i] -in @('H','W')
            }

            $soundexTail = ($soundex.ToString().Substring(1)).TrimStart((ConvertTo-SoundexDigit $String[0]).ToString())

            [PSCustomObject]@{
                String  = $originalString
                Soundex = ($soundex[0] + $soundexTail).PadRight(4,"0").Substring(0,4)
            }
        }
    }
}
