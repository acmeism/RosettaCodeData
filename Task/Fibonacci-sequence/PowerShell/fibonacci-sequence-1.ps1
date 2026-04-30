function FibonacciNumber ( $count )
{
    $answer = @(0,1)
    while ($answer.Length -le $count)
    {
        $answer += $answer[-1] + $answer[-2]
    }
    return $answer
}
