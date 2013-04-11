sub fib ($n, @xs is copy = [1]) {
    gather {
        take @xs[*];
        loop {
            take my $x = [+] @xs;
            @xs.push: $x;
            @xs.shift if @xs > $n;
        }
    }
}

for 2..10 -> $n {
    say fib($n, [1])[^20];
}
say fib(2, [2,1])[^20];
