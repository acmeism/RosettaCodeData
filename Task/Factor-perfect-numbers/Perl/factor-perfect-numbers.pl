use v5.36;

sub table (@V) { my $t = 3 * (my $w = 2 + 20); ( sprintf( ('%-'.$w.'s')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

sub proper_divisors ($x) {
    my @l;
    @l = 1 if $x > 1;
    for my $d (2 .. int sqrt $x) {
        if (0 == $x % $d) { push @l, $d; my $y = int($x/$d); push @l, $y if $y != $d }
    }
    @l
}

sub erdosFactorCount ($n) {
    my @foo = proper_divisors($n); shift @foo;
    state %cache;
    my ($sum,@divs) = (0, @foo); #(proper_divisors $n)[1..*]);
    for my $d (@divs) {
        my $t = int($n/$d);
        $cache{$t} = erdosFactorCount($t) unless $cache{$t};
        $sum += $cache{$t}
    }
    ++$sum
}

sub moreMultiples ($to, $from) {
    my @oneMores;
    for my $j (@$from) {
        push @oneMores, [@$to, $j] if $j > $$to[-1] && 0 == $j % $$to[-1]
    }
    return unless @oneMores;
    for (0 .. $#oneMores) {
        push @oneMores, moreMultiples($oneMores[$_], $from);
    }
    @oneMores
}

my @listing = [1];
push @listing, moreMultiples [1], [proper_divisors(48)];
map { push @$_, 48 } @listing;

my @lists; map { push @lists, join ' ', @$_ } @listing;
say @listing . " sequences using first definition:\n" . table(@lists);

my @listing2;
for my $j (0.. $#listing) {
    my @seq = @{$listing[$j]};
    push @seq, 48 if $seq[-1] != 48;
    push @listing2, join ' ', map { int $seq[$_] / $seq[$_-1] } 1 .. $#seq;
}

say @listing2 . " sequences using second definition:\n" . table(@listing2);

my($n,@fpns) = (4, 0,1);
while ($#fpns < 6) { push(@fpns, $n) if erdosFactorCount($n) == $n; $n += 4 }
say "OEIS A163272: @fpns";
