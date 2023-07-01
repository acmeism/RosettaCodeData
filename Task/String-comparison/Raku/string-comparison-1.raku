sub compare($a,$b) {
    my $A = "{$a.WHAT.^name} '$a'";
    my $B = "{$b.WHAT.^name} '$b'";

    if $a eq $b { say "$A and $B are lexically equal" }
    if $a ne $b { say "$A and $B are not lexically equal" }

    if $a gt $b { say "$A is lexically after $B" }
    if $a lt $b { say "$A is lexically before than $B" }

    if $a ge $b { say "$A is not lexically before $B" }
    if $a le $b { say "$A is not lexically after $B" }

    if $a === $b { say "$A and $B are identical objects" }
    if $a !=== $b { say "$A and $B are not identical objects" }

    if $a eqv $b { say "$A and $B are generically equal" }
    if $a !eqv $b { say "$A and $B are not generically equal" }

    if $a before $b { say "$A is generically after $B" }
    if $a after $b { say "$A is generically before $B" }

    if $a !after $b { say "$A is not generically before $B" }
    if $a !before $b { say "$A is not generically after $B" }

    say "The lexical relationship of $A and $B is { $a leg $b }" if $a ~~ Stringy;
    say "The generic relationship of $A and $B is { $a cmp $b }";
    say "The numeric relationship of $A and $B is { $a <=> $b }" if $a ~~ Numeric;
    say '';
}

compare 'YUP', 'YUP';
compare 'BALL', 'BELL';
compare 24, 123;
compare 5.1, 5;
compare 5.1e0, 5 + 1/10;
