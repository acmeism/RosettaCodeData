sub fiboword;
{
    my ($a, $b, $count) = (1, 0, 0);
    sub fiboword {
        $count++;
        return $a if $count == 1;
        return $b if $count == 2;
        ($a, $b) = ($b, "$b$a");
        return $b;
    }
}
sub entropy {
    my %c;
    $c{$_}++ for split //, my $str = shift;
    my $e = 0;
    for (values %c) {
        my $p = $_ / length $str;
        $e -= $p * log $p;
    }
    return $e / log 2;
}

my $count;
while ($count++ < 37) {
    my $word = fiboword;
    printf "%5d\t%10d\t%.8e\t%s\n",
    $count,
    length($word),
    entropy($word),
    $count > 9 ? '' : $word
}
