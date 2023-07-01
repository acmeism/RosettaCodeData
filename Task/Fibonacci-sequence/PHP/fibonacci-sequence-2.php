function fibRec($n) {
    return $n < 2 ? $n : fibRec($n-1) + fibRec($n-2);
}
