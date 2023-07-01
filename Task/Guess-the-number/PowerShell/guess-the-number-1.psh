Function GuessNumber($Guess)
{
    $Number = Get-Random -min 1 -max 11
    Write-Host "What number between 1 and 10 am I thinking of?"
        Do
        {
        Write-Warning "Try again!"
        $Guess = Read-Host "What's the number?"
        }
        While ($Number -ne $Guess)
    Write-Host "Well done! You successfully guessed the number $Guess."
}
