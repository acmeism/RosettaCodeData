function prime-decomposition ($n) {
    $values = [System.Collections.Generic.List[string]]::new()
    while ((($n % 2) -eq 0) -and ($n -gt 2)) {
        $values.Add(2)
        $n /= 2
    }
    for ($i = 3; $n -ge ($i * $i); $i += 2) {
        if (($n % $i) -eq 0){
            $values.Add($i)
            $n /= $i
            $i -= 2
        }
    }
    $values.Add($n)
    return $values
}
"$(prime-decomposition 1000000)"
