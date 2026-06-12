my $n = 17;
my @a = [ 0 xx $n ] xx $n;
@a[$_;$_] = '-' for ^$n;

for flat ^$n X 1,2,4,8 -> $i, $k {
    my $j = ($i + $k) % $n;
    @a[$i;$j] = @a[$j;$i] = 1;
}
.say for @a;

for combinations($n,4) -> $quartet {
    my $links = [+] $quartet.combinations(2).map: -> $i,$j { @a[$i;$j] }
    die "Bogus!" unless 0 < $links < 6;
}
say "OK";
