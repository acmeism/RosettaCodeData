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

Function Get-Legendre ([BigInt]$Integer, [BigInt]$Prime) {
    return (Invoke-ModuloExponentiation -Base $Integer -Exponent (($Prime - 1) / 2) -Modulo $Prime)
}

Function Invoke-TonelliShanks ([BigInt]$Integer, [BigInt]$Prime) {
    If ((Get-Legendre $Integer $Prime) -ne 1) {throw "$Integer not a square (mod $Prime)"}
    [bigint]$q = $Prime - 1
    $s = 0
    While (($q % 2) -eq 0) {
        $q = $q / 2
        $s++
    }
    If ($s -eq 1) {
        return (Invoke-ModuloExponentiation $Integer -Exponent (($Prime + 1) / 4) -Modulo $Prime)
    }
    For ($z = 2; [Bigint]::Compare($z, $Prime) -lt 0; $z++) {
        If ([BigInt]::Compare(($Prime - 1), (Get-Legendre $z $Prime)) -eq 0) {
            break
        }
    }
    $c = Invoke-ModuloExponentiation -Base $z -Exponent $q -Modulo $Prime
    $r = Invoke-ModuloExponentiation -Base $Integer -Exponent (($q + 1) / 2) -Modulo $Prime
    $t = Invoke-ModuloExponentiation -Base $Integer -Exponent $q -Modulo $Prime
    $m = $s
    $t2 = 0

    While ((($t - 1) % $Prime) -ne 0) {
        $t2 = $t * $t % $Prime
        Foreach ($i in (1..$m)) {
            If ((($t2 -1) % $Prime) -eq 0) {
                break
            }
            $t2 = Invoke-ModuloExponentiation -Base $t2 -Exponent 2 -Modulo $Prime
        }
        $b = Invoke-ModuloExponentiation -Base $c -Exponent ([Math]::Pow(2, ($m - $i - 1))) -Modulo $Prime
        $r = ($r * $b) % $Prime
        $c = ($b * $b) % $Prime
        $t = ($t * $c) % $Prime
        $m = $i
    }
    return $r
}

$TonelliTests = @(
    @{Integer = [BigInt]::Parse('10'); Prime = [BigInt]::Parse('13')},
    @{Integer = [BigInt]::Parse('56'); Prime = [BigInt]::Parse('101')},
    @{Integer = [BigInt]::Parse('1030'); Prime = [BigInt]::Parse('10009')},
    @{Integer = [BigInt]::Parse('44402'); Prime = [BigInt]::Parse('100049')},
    @{Integer = [BigInt]::Parse('665820697'); Prime = [BigInt]::Parse('1000000009')},
    @{Integer = [BigInt]::Parse('881398088036'); Prime = [BigInt]::Parse('1000000000039')},
    @{Integer = [BigInt]::Parse('41660815127637347468140745042827704103445750172002'); Prime = [BigInt]::Parse('100000000000000000000000000000000000000000000000577')}
)

$TonelliTests | Foreach-Object {
    $Result = Invoke-TonelliShanks @_
    [PSCustomObject]@{
        n = $_['Integer']
        p = $_['Prime']
        Roots = @($Result, ($_['Prime'] - $Result))
    }
} | Format-List
