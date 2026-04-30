#  Define the items to pack
$Item = @(
    [pscustomobject]@{ Name = 'panacea'; Unit = 'vials'  ; value = 3000; Weight = 0.3; Volume = 0.025 }
    [pscustomobject]@{ Name = 'ichor'  ; Unit = 'ampules'; value = 1800; Weight = 0.2; Volume = 0.015 }
    [pscustomobject]@{ Name = 'gold'   ; Unit = 'bars'   ; value = 2500; Weight = 2.0; Volume = 0.002 }
    )

#  Define our maximums
$MaxWeight = 25
$MaxVolume = 0.25

#  Set our default value to beat
$OptimalValue = 0

#  Iterate through the possible quantities of item 0, without going over the weight or volume limit
ForEach ( $Qty0 in 0..( [math]::Min( [math]::Truncate( $MaxWeight / $Item[0].Weight ), [math]::Truncate( $MaxVolume / $Item[0].Volume ) ) ) )
    {
    #  Calculate the remaining space
    $RemainingWeight = $MaxWeight - $Qty0 * $Item[0].Weight
    $RemainingVolume = $MaxVolume - $Qty0 * $Item[0].Volume

    #  Iterate through the possible quantities of item 1, without going over the weight or volume limit
    ForEach ( $Qty1 in 0..( [math]::Min( [math]::Truncate( $RemainingWeight / $Item[1].Weight ), [math]::Truncate( $RemainingVolume / $Item[1].Volume ) ) ) )
        {
        #  Calculate the remaining space
        $RemainingWeight2 = $RemainingWeight - $Qty1 * $Item[1].Weight
        $RemainingVolume2 = $RemainingVolume - $Qty1 * $Item[1].Volume

        #  Calculate the maximum quantity of item 2 for the remaining space, without going over the weight or volume limit
        $Qty2 = [math]::Min( [math]::Truncate( $RemainingWeight2 / $Item[2].Weight ), [math]::Truncate( $RemainingVolume2 / $Item[2].Volume ) )

        #  Calculate the total value of the items packed
        $TrialValue =   $Qty0 * $Item[0].Value +
                        $Qty1 * $Item[1].Value +
                        $Qty2 * $Item[2].Value

        #  Describe the trial solution
        $Solution  = "$Qty0 $($Item[0].Unit) of $($Item[0].Name), "
        $Solution += "$Qty1 $($Item[1].Unit) of $($Item[1].Name), and "
        $Solution += "$Qty2 $($Item[2].Unit) of $($Item[2].Name) worth a total of $TrialValue."

        #  If the trial value is higher than previous most valuable trial...
        If ( $TrialValue -gt $OptimalValue )
            {
            #  Set the new number to beat
            $OptimalValue = $TrialValue

            #  Overwrite the previous optimal solution(s) with the trial solution
            $Solutions  = @( $Solution )
            }

        #  Else if the trial value matches the previous most valuable trial...
       ElseIf ( $TrialValue -eq $OptimalValue )
            {
            #  Add the trial solution to the list of optimal solutions
            $Solutions += @( $Solution )
            }
        }
    }

#  Show the results
$Solutions
