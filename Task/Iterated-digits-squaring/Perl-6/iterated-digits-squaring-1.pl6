constant @sq = ^10 X** 2;
my $cnt = 0;
my %cache;

sub Euler92($n) {
    %cache{$n} //=
    $n == any(1,89) ?? $n !!
    Euler92( [+] @sq[$n.comb] )
}

for 1 .. 1_000_000 -> $n {
   my $i = +$n.comb.sort.join;
   ++$cnt if Euler92($i) == 89;
}

say $cnt;
