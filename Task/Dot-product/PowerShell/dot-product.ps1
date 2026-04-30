function dotproduct( $a, $b) {
    $a | foreach -Begin {$i = $res = 0} -Process { $res += $_*$b[$i++] } -End{$res}
}
dotproduct (1..2) (1..2)
dotproduct (1..10) (11..20)
