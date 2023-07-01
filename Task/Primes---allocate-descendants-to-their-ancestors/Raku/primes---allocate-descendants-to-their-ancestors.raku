my $max = 99;
my @primes = (2 .. $max).grep: *.is-prime;
my %tree;
(1..$max).map: {
    %tree{$_}<ancestor> = ();
    %tree{$_}<descendants> = {};
};


sub allocate ($n, $i = 0, $sum = 0, $prod = 1) {
    return if $n < 4;
    for @primes.kv -> $k, $p {
        next if $k < $i;
        if ($sum + $p) <= $n {
            allocate($n, $k, $sum + $p, $prod * $p);
        } else {
            last if $sum == $prod;
            %tree{$sum}<descendants>{$prod} = True;
            last if $prod > $max;
            %tree{$prod}<ancestor> = %tree{$sum}<ancestor> (|) $sum;
            last;
        }
    }
}

# abbreviate long lists to first and last 5 elements
sub abbrev (@d) { @d < 11 ?? @d !! ( @d.head(5), '...', @d.tail(5) ) }

my @print = flat 1 .. 15, 46, 74, $max;

(1 .. $max).map: -> $term {
    allocate($term);

    if $term == any( @print )  # print some representative lines
    {
        my $dn = +%tree{$term}<descendants> // 0;
        my $dl = abbrev(%tree{$term}<descendants>.keys.sort( +*) // ());
        printf "%2d, %2d Ancestors: %-14s %5d Descendants: %s\n",
          $term, %tree{$term}<ancestor>,
          "[{ %tree{$term}<ancestor>.keys.sort: +* }],", $dn, "[$dl]";
    }
}

say "\nTotal descendants: ",
  sum (1..$max).map({ +%tree{$_}<descendants> });
