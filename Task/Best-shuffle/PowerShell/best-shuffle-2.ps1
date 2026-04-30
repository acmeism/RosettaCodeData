ForEach ( $String in ( 'abracadabra', 'seesaw', 'elk', 'grrrrrr', 'up', 'a' ) )
    {
    $Shuffle = Get-BestShuffle $String
    $Score   = Get-BestScore   $String
    "$String, $Shuffle, ($Score)"
    }
