function gcdRec($n, $m) {
    if($m > 0) {
        return gcdRec($m, $n % $m);
    } else {
        return abs($n);
    }
}
