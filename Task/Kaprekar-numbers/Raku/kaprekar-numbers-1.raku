sub kaprekar( Int $n ) {
    my $sq = $n ** 2;
    for 0 ^..^ $sq.chars -> $i {
        my $x = +$sq.substr(0, $i);
        my $y = +$sq.substr($i) || return;
        return True if $x + $y == $n;
    }
    False;
}

print 1;
print " $_" if .&kaprekar for ^10000;
print "\n";
