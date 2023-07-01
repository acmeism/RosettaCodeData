#adding the below function to the previous users submission to prevent the small
#chance of getting an array that is in ascending order.

#Full disclosure: I am an infrastructure engineer, not a dev. My code is likely
#bad.

function generateArray{
    $fArray = 1..9 | Get-Random -Count 9
    if (-join $fArray -eq -join @(1..9)){
        generateArray
    }
    return $fArray
}
$array = generateArray

#everything below is untouched from original submission
$nTries = 0
While(-join $Array -ne -join @(1..9)){
    $nTries++
    $nReverse = Read-Host -Prompt "[$Array] -- How many digits to reverse? "
    [Array]::Reverse($Array,0,$nReverse)
}
"$Array"
"Your score: $nTries"
