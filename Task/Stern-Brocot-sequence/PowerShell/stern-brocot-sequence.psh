# An iterative approach
function iter_sb($count = 2000)
{
    # Taken from RosettaCode GCD challenge
    function Get-GCD ($x, $y)
    {
        if ($y -eq 0) { $x } else { Get-GCD $y ($x%$y) }
    }

    $answer = @(1,1)
    $index = 1
    while ($answer.Length -le $count)
    {
        $answer += $answer[$index] + $answer[$index - 1]
        $answer += $answer[$index]
        $index++
    }

    0..14 | foreach {$answer[$_]}

    1..10 | foreach {'Index of {0}: {1}' -f $_, ($answer.IndexOf($_) + 1)}

    'Index of 100: {0}' -f ($answer.IndexOf(100) + 1)

    [bool] $gcd = $true
    1..999 | foreach {$gcd = $gcd -and ((Get-GCD $answer[$_] $answer[$_ - 1]) -eq 1)}
    'GCD = 1 for first 1000 members: {0}' -f $gcd
}
