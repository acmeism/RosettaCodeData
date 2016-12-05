function Get-ZeckendorfNumber ( $N )
    {
    #  Calculate relevant portation of Fibonacci series
    $Fib = @( 1, 1 )
    While ( $Fib[-1] -lt $N ) { $Fib += $Fib[-1] + $Fib[-2] }

    #  Start with 0
    $ZeckendorfNumber = 0

    #  For each number in the relevant portion of Fibonacci series
    For ( $i = $Fib.Count - 1; $i -gt 0; $i-- )
        {
        #  If Fibonacci number is less than or equal to remainder of N
        If ( $Fib[$i] -le $N )
            {
            #  Double Z number and add 1 (equivalent to adding a '1' to the end of a binary number)
            $ZeckendorfNumber = $ZeckendorfNumber * 2 + 1
            #  Reduce N by Fibonacci number, skip next Fibonacci number
            $N -= $Fib[$i--]
            }
        #  If were aren't finished yet, double Z number
        #  (equivalent to adding a '0' to the end of a binary number)
        If ( $i ) { $ZeckendorfNumber *= 2 }
        }
    return $ZeckendorfNumber
    }
