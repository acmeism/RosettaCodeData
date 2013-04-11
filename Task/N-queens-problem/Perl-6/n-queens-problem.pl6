sub MAIN($N = 8) {
    sub collision(@field, $row) {
        for ^$row -> $i {
            my $distance = @field[$i] - @field[$row];
            return 1 if $distance == any(0, $row - $i, $i - $row);
        }
        0;
    }
    sub search(@field is rw, $row) {
        if $row == $N {
            return @field;
        } else {
            for ^$N -> $i {
                @field[$row] = $i;
                if !collision(@field, $row) {
                    my @r = search(@field, $row + 1) and return @r;
                }
            }
        }
        Nil;
    }
    for 0 .. $N / 2 {
        if my @f = search [$_], 1 {
            say ~@f;
            last;
        }
    }
}
# output:
0 4 7 5 2 6 1 3
