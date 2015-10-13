function fact([BigInt]$n){
    if($n -ge ([BigInt]::Zero)) {
        $fact = [BigInt]::One
        ([BigInt]::One)..$n | foreach{
            $fact = [BigInt]::Multiply($fact, $_)
        }
        $fact

    } else {
        Write-Error "$n is lower than 0"
    }
}
"$((Measure-Command {$fact = fact 10}).TotalSeconds) Seconds"
$fact
