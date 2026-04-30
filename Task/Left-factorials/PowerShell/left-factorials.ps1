function left-factorial ([BigInt]$n) {
    [BigInt]$k, [BigInt]$fact = ([BigInt]::Zero), ([BigInt]::One)
    [BigInt]$lfact = ([BigInt]::Zero)
    while($k -lt $n){
        if($k -gt ([BigInt]::Zero)) {
            $fact = [BigInt]::Multiply($fact, $k)
            $lfact = [BigInt]::Add($lfact, $fact)
        } else {
            $lfact = ([BigInt]::One)
        }
        $k = [BigInt]::Add($k, [BigInt]::One)
    }
    $lfact
}
0..9 | foreach{
    "!$_ = $(left-factorial $_)"
}
for($i = 10; $i -le 110; $i += 10) {
    "!$i = $(left-factorial $i)"
}
for($i = 1000; $i -le 10000; $i += 1000) {
    $digits = [BigInt]::Log10($(left-factorial $i))
    $digits = [Math]::Floor($digits) + 1
    if($digits -gt 1) {"!$i has $digits digits"}
    else {"!$i has $digits digit"}
}
