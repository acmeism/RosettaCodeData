function Get-Guess
{
    [int]$number = 1..100 | Get-Random
    [int]$guess = 0
    [int[]]$guesses = @()

    Write-Host "Guess a number between 1 and 100" -ForegroundColor Cyan

    while ($guess -ne $number)
    {
        try
        {
            [int]$guess = Read-Host -Prompt "Guess"

            if ($guess -lt $number)
            {
                Write-Host "Greater than..."
            }
            elseif ($guess -gt $number)
            {
                Write-Host "Less than..."
            }
            else
            {
                Write-Host "You guessed it"
            }
        }
        catch [Exception]
        {
            Write-Host "Input a number between 1 and 100." -ForegroundColor Yellow
            continue
        }

        $guesses += $guess
    }

    [PSCustomObject]@{
        Number  = $number
        Guesses = $guesses
    }
}

$answer = Get-Guess

Write-Host ("The number was {0} and it took {1} guesses to find it." -f $answer.Number, $answer.Guesses.Count)
