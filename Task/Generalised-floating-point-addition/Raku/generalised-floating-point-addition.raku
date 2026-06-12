my $e = 63;
for -7..21 -> $n {
    my $num = '12345679' ~ '012345679' x ($n+7);
    my $sum = $_ + ($num * $_) * 81 given $e > -20 ?? 10**$e !! Rat.new(1,10**abs $e);
    printf "$n:%s ", 10**72 == $sum ?? 'Y' !! 'N';
    $e -= 9;
}
