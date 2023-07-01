function Catalan([uint64]$m) {
    function fact([bigint]$n) {
        if($n -lt 2) {[bigint]::one}
        else{2..$n | foreach -Begin {$prod = [bigint]::one} -Process {$prod = [bigint]::Multiply($prod,$_)} -End {$prod}}
    }
    $fact = fact $m
    $fact1 = [bigint]::Multiply($m+1,$fact)
    [bigint]::divide((fact (2*$m)), [bigint]::Multiply($fact,$fact1))
}
0..15 | foreach {"catalan($_): $(catalan $_)"}
