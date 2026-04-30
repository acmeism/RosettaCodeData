# Floors are numbered 1 (ground) to 5 (top)

# Baker, Cooper, Fletcher, Miller, and Smith live on different floors:
$statement1 = '$baker  -ne $cooper -and $baker    -ne $fletcher -and $baker    -ne $miller -and
               $baker  -ne $smith  -and $cooper   -ne $fletcher -and $cooper   -ne $miller -and
               $cooper -ne $smith  -and $fletcher -ne $miller   -and $fletcher -ne $smith  -and
               $miller -ne $smith'

# Baker does not live on the top floor:
$statement2 = '$baker -ne 5'

# Cooper does not live on the bottom floor:
$statement3 = '$cooper -ne 1'

# Fletcher does not live on either the top or the bottom floor:
$statement4 = '$fletcher -ne 1 -and $fletcher -ne 5'

# Miller lives on a higher floor than does Cooper:
$statement5 = '$miller -gt $cooper'

# Smith does not live on a floor adjacent to Fletcher's:
$statement6 = '[Math]::Abs($smith - $fletcher) -ne 1'

# Fletcher does not live on a floor adjacent to Cooper's:
$statement7 = '[Math]::Abs($fletcher - $cooper) -ne 1'

for ($baker = 1; $baker -lt 6; $baker++)
{
    for ($cooper = 1; $cooper -lt 6; $cooper++)
    {
        for ($fletcher = 1; $fletcher -lt 6; $fletcher++)
        {
            for ($miller = 1; $miller -lt 6; $miller++)
            {
                for ($smith = 1; $smith -lt 6; $smith++)
                {
                    if (Invoke-Expression $statement2)
                    {
                        if (Invoke-Expression $statement3)
                        {
                            if (Invoke-Expression $statement5)
                            {
                                if (Invoke-Expression $statement4)
                                {
                                    if (Invoke-Expression $statement6)
                                    {
                                        if (Invoke-Expression $statement7)
                                        {
                                            if (Invoke-Expression $statement1)
                                            {
                                                $multipleDwellings = @()
                                                $multipleDwellings+= [PSCustomObject]@{Name = "Baker"   ; Floor = $baker}
                                                $multipleDwellings+= [PSCustomObject]@{Name = "Cooper"  ; Floor = $cooper}
                                                $multipleDwellings+= [PSCustomObject]@{Name = "Fletcher"; Floor = $fletcher}
                                                $multipleDwellings+= [PSCustomObject]@{Name = "Miller"  ; Floor = $miller}
                                                $multipleDwellings+= [PSCustomObject]@{Name = "Smith"   ; Floor = $smith}
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
