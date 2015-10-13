multi sub pascal (1) { $[1] }
multi sub pascal (Int $n where 2..*) {
    my @rows = pascal $n - 1;
    |@rows, [0, |@rows[*-1] Z+ |@rows[*-1], 0 ];
}

.say for pascal 10;
