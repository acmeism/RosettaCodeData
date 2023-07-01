proc rfact n {
    expr {$n < 2 ? 1 : $n * [rfact [incr n -1]]}
}
