[int]$guesses = $bulls = $cows = 0
[string]$guess = "none"
[string]$digits = ""

while ($digits.Length -lt 4)
{
    $character = [char](49..57 | Get-Random)

    if ($digits.IndexOf($character) -eq -1) {$digits += $character}
}

Write-Host "`nGuess four digits (1-9) using no digit twice.`n" -ForegroundColor Cyan

while ($bulls -lt 4)
{
    do
    {
        $prompt = "Guesses={0:0#}, Last='{1,4}', Bulls={2}, Cows={3}; Enter your guess" -f $guesses, $guess, $bulls, $cows
        $guess = Read-Host $prompt

        if ($guess.Length -ne 4)                     {Write-Host "`nMust be a four-digit number`n" -ForegroundColor Red}
        if ($guess -notmatch "[1-9][1-9][1-9][1-9]") {Write-Host "`nMust be numbers 1-9`n"         -ForegroundColor Red}
    }
    until ($guess.Length -eq 4)

    $guesses += 1
    $bulls = $cows = 0

    for ($i = 0; $i -lt 4; $i++)
    {
        $character = $digits.Substring($i,1)

        if ($guess.Substring($i,1) -eq $character)
        {
            $bulls += 1
        }
        else
        {
            if ($guess.IndexOf($character) -ge 0)
            {
                $cows += 1
            }
        }
    }
}

Write-Host "`nYou won after $($guesses - 1) guesses." -ForegroundColor Cyan
