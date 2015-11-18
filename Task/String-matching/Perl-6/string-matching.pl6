my @subs = (
    # Regex-based:
    sub R_contains    ( Str $_, Str $s2 ) { ? m/   $s2   / },
    sub R_starts_with ( Str $_, Str $s2 ) { ? m/ ^ $s2   / },
    sub R_ends_with   ( Str $_, Str $s2 ) { ? m/   $s2 $ / },

    # Index-based:
    sub I_contains    ( Str $_, Str $s2 ) {         .index( $s2)    .defined },
    sub I_starts_with ( Str $_, Str $s2 ) { my $m = .index( $s2); $m.defined and $m == 0 },
    sub I_ends_with   ( Str $_, Str $s2 ) { my $m = .rindex($s2); $m.defined and $m == .chars - $s2.chars },

    # Substr-based:
    sub S_starts_with ( Str $_, Str $s2 ) { .substr(0, $s2.chars) eq $s2 },
    sub S_ends_with   ( Str $_, Str $s2 ) { .substr( *-$s2.chars) eq $s2 },

    # Optional tasks:
    sub R_find        ( Str $_, Str $s2 ) { $/.from if /$s2/ },
    sub R_find_all    ( Str $_, Str $s2 ) {
        my @p = .match: /$s2/, :g;
        @p».from if @p;
    },
);

my $str1 = 'abcbcbcd';
my @str2s = < ab bc cd zz >;

say "'$str1' vs:".fmt('%15s '), @str2s.fmt('%-15s');
for [1, 4, 6], [2, 5, 7], [0, 3], [8, 9] {
    say();
    for @subs[.list] -> $sub {
        say "{$sub.name}:".fmt('%15s '),
            @str2s.map({ ~$sub.($str1, $_) }).fmt('%-15s');
    }
}
