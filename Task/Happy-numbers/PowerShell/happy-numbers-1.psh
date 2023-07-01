function happy([int] $n) {
    $a=@()
    for($i=2;$a.count -lt $n;$i++) {
        $sum=$i
        $hist=@{}
        while( $hist[$sum] -eq $null ) {
            if($sum -eq 1) {
                $a+=$i
            }
            $hist[$sum]=$sum
            $sum2=0
            foreach($j in $sum.ToString().ToCharArray()) {
                $k=([int]$j)-0x30
                $sum2+=$k*$k
            }
            $sum=$sum2
        }
    }
    $a -join ','
}
