sub self-contained ($n) {
    my $m = $n;
    while $m > 1 {
        $m %% 2 ?? ($m div= 2) !! ($m = $m * 3 + 1);
        return True if $m %% $n;
    }
    False;
}

say (^Inf).map(* * 2 + 1).hyper(:1000batch).map({ $_ if .&self-contained })[^7]
