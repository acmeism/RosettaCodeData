function randN ( [int]$N )
    {
    [int]( ( Get-Random -Maximum $N ) -eq 0 )
    }

function unbiased ( [int]$N )
    {
    do  {
        $X = randN $N
        $Y = randN $N
        }
    While ( $X -eq $Y )

    return $X
    }
