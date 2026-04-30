function Read-ArrayIndex ([string]$Prompt = "Enter an integer greater than zero")
{
    [int]$inputAsInteger = 0

    while (-not [Int]::TryParse(([string]$inputString = Read-Host $Prompt), [ref]$inputAsInteger))
    {
        $inputString = Read-Host "Enter an integer greater than zero"
    }

    if ($inputAsInteger -gt 0) {return $inputAsInteger} else {return 1}
}

$x = $y = $null

do
{
    if ($x -eq $null) {$x = Read-ArrayIndex -Prompt "Enter two dimensional array index X"}
    if ($y -eq $null) {$y = Read-ArrayIndex -Prompt "Enter two dimensional array index Y"}
}
until (($x -ne $null) -and ($y -ne $null))

$array2d = New-Object -TypeName 'System.Object[,]' -ArgumentList $x, $y
