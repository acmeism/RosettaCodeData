proto combs_with_rep (Int, @) {*}

multi combs_with_rep (0,  @)  { [] }
multi combs_with_rep ($,  []) { () }
multi combs_with_rep ($n, [$head, *@tail]) {
    map( { [$head, @^others] },
            combs_with_rep($n - 1, [$head, @tail]) ),
    combs_with_rep($n, @tail);
}

.perl.say for combs_with_rep( 2, [< iced jam plain >] );

# Extra credit:
sub postfix:<!> { [*] 1..$^n }
sub combs_with_rep_count ($k, $n) { ($n + $k - 1)! / $k! / ($n - 1)! }

say combs_with_rep_count( 3, 10 );
