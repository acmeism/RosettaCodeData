sub combinations(Int $n, Int $k) {
    return [] if $k == 0;
    return () if $k > $n;
    gather {
        take [0, (1..^$n)[@$_]] for combinations($n-1, $k-1);
        take [(1..^$n)[@$_]]    for combinations($n-1, $k  );
    }
}

.say for combinations(5, 3);
