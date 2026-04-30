function fun($n){
    $res = 0
    if($n -gt 0) {
        1..$n | foreach{
            $a, $b = $_, ($n+$_)
            $res += $a + $b
        }

    }
    $res
}
"$((Measure-Command {fun 10000}).TotalSeconds) Seconds"
