function Get-EquilibriumIndex ( $Sequence )
    {
    $Indexes = 0..($Sequence.Count - 1)
    $EqulibriumIndex = @()

    ForEach ( $TestIndex in $Indexes )
        {
        $Left = 0
        $Right = 0
        ForEach ( $Index in $Indexes )
            {
            If     ( $Index -lt $TestIndex ) { $Left  += $Sequence[$Index] }
            ElseIf ( $Index -gt $TestIndex ) { $Right += $Sequence[$Index] }
            }

        If ( $Left -eq $Right )
            {
            $EqulibriumIndex += $TestIndex
            }
        }
    return $EqulibriumIndex
    }
