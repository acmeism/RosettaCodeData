function Get-RandomChess960Start
    {
    $Starts = @()

    ForEach ( $Q  in       0..3 ) {
    ForEach ( $N1 in       0..4 ) {
    ForEach ( $N2 in ($N1+1)..5 ) {
    ForEach ( $B1 in       0..3 ) {
    ForEach ( $B2 in       0..3 ) {
        $BB = $B1 * 2 + ( $B1 -lt $B2 )
        $BW = $B2 * 2
        $Start = [System.Collections.ArrayList]( '♖', '♔', '♖' )
        $Start.Insert( $Q , '♕' )
        $Start.Insert( $N1, '♘' )
        $Start.Insert( $N2, '♘' )
        $Start.Insert( $BB, '♗' )
        $Start.Insert( $BW, '♗' )
        $Starts += ,$Start
        }}}}}

    $Index = Get-Random 960
    $StartString = $Starts[$Index] -join ''
    return $StartString
    }

Get-RandomChess960Start
Get-RandomChess960Start
Get-RandomChess960Start
Get-RandomChess960Start
