sub genfizzbuzz($n, +@fb) {
    [Z~](
        do for @fb || <3 fizz 5 buzz> -> $i, $s {
            flat ('' xx $i-1, $s) xx *;
        }
    ) Z|| 1..$n
}

.say for genfizzbuzz(20, <3 Fizz 5 Buzz 7 Baxx>);
