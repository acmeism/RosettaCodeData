for $i (
     [ -2,    2,    1], #1 Normal
     [ -2,    2,    0], #2 Zero increment
     [ -2,    2,   -1], #3 Increments away from stop value
     [ -2,    2,   10], #4 First increment is beyond stop value
     [  2,   -2,    1], #5 Start more than stop: positive increment
     [  2,    2,    1], #6 Start equal stop: positive increment
     [  2,    2,   -1], #7 Start equal stop: negative increment
     [  2,    2,    0], #8 Start equal stop: zero increment
     [  0,    0,    0], #9 Start equal stop equal zero: zero increment
) {
    $iter = gen_seq(@$i);
    printf "start: %3d  stop: %3d  incr: %3d | ", @$i;
    printf "%4s", &$iter for 1..10;
    print "\n";
}

sub gen_seq {
    my($start,$stop,$increment) = @_;
    $n = 0;
    return sub {
        $term = $start + $n++ * $increment;
        return $term > $stop ? '' : $term;
    }
}
