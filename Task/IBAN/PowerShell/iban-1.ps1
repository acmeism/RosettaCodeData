function verifIBAN ([string]$ibanS)
{
if ($ibanS.Length -ne 27) {return $false} else
{
$ibanI="$($ibanS.Substring(4,23))$($ibanS.Substring(0,4))".ToUpper()
[int]$comptIBAN=0
$NumIBAN=""
while ($comptIBAN -lt 27)
    {
    if ([byte]$ibanI[$comptIBAN] -ge 65 -and [byte]$ibanI[$comptIBAN] -le 90)
        {
        $NumIban+=([byte]$ibanI[$comptIBAN]-55)
        } #pour transformer les lettres en chiffres (A=10, B=11...)
        else
        {
        $NumIban+=$ibanI[$comptIBAN]
        }
    $comptIBAN++
    }
    #cela fait un nombre de 30 chiffres : trop pour powershell, je découpe donc les 9 premiers caractères :
if ("$($NumIBAN.Substring(0,9)%97)$($NumIBAN.Substring(9,$NumIBAN.Length-9))"%97 -eq 1)
    {return $true}
    else
    {return $false}
}
} #fin fonction vérification IBAN / Stéphane RABANY 2018
