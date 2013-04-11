foreach proc {gcd_iter gcd gcd_bin} {
    puts [format "%-8s - %s" $proc [time {$proc $u $v} 100000]]
}
