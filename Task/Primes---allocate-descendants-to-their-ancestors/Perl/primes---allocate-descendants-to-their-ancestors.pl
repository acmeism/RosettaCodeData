use List::Util qw(sum uniq);
use ntheory qw(nth_prime);

my $max = 99;
my %tree;

sub allocate {
    my($n, $i, $sum,, $prod) = @_;
    $i //= 0; $sum //= 0; $prod //= 1;

    for my $k (0..$max) {
        next if $k < $i;
        my $p = nth_prime($k+1);
        if (($sum + $p) <= $max) {
            allocate($n, $k, $sum + $p, $prod * $p);
        } else {
            last if $sum == $prod;
            $tree{$sum}{descendants}{$prod} = 1;
            $tree{$prod}{ancestor} = [uniq $sum, @{$tree{$sum}{ancestor}}] unless $prod > $max || $sum == 0;
            last;
        }
    }
}

sub abbrev { # abbreviate long lists to first and last 5 elements
    my(@d) = @_;
    return @d if @d < 11;
    @d[0 .. 4], '...', @d[-5 .. -1];
}

allocate($_) for 1 .. $max;

for (1 .. 15, 46, $max) {
    printf "%2d, %2d Ancestors: %-15s", $_, (scalar uniq @{$tree{$_}{ancestor}}),
        '[' . join(' ',uniq @{$tree{$_}{ancestor}}) . ']';
    my $dn = 0; my $dl = '';
    if ($tree{$_}{descendants}) {
        $dn = keys %{$tree{$_}{descendants}};
        $dl = join ' ', abbrev(sort { $a <=> $b } keys %{$tree{$_}{descendants}});
    }
    printf "%5d Descendants: %s", $dn, "[$dl]\n";
}

map { for my $k (keys %{$tree{$_}{descendants}}) { $total += $tree{$_}{descendants}{$k} } } 1..$max;
print "\nTotal descendants: $total\n";
