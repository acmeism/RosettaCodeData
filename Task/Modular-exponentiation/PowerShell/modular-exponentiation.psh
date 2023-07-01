Function Invoke-ModuloExponentiation ([BigInt]$Base, [BigInt]$Exponent, $Modulo) {
    $Result = 1
    $Base = $Base % $Modulo
    If ($Base -eq 0) {return 0}

    While ($Exponent -gt 0) {
        If (($Exponent -band 1) -eq 1) {$Result = ($Result * $Base) % $Modulo}
        $Exponent = $Exponent -shr 1
        $Base = ($Base * $Base) % $Modulo
    }
    return ($Result % $Modulo)
}

$a = [BigInt]::Parse('2988348162058574136915891421498819466320163312926952423791023078876139')
$b = [BigInt]::Parse('2351399303373464486466122544523690094744975233415544072992656881240319')
$m = [BigInt]::Pow(10, 40)

Invoke-ModuloExponentiation -Base $a -Exponent $b -Modulo $m
