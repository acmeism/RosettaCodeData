function gcdIter($n, $m) {
    while(true) {
        if($n == $m) {
            return $m;
        }
        if($n > $m) {
            $n -= $m;
        } else {
            $m -= $n;
        }
    }
}
