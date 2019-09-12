sub div_sum {
    my($n) = @_;
    my $sum = 0;
    map { $sum += $_ unless $n % $_ } 1 .. $n-1;
    $sum;
}

my @type = <Perfect Abundant Deficient>;
say join "\n", map { sprintf "%2d %s", $_, $type[div_sum($_) <=> $_] } 1..12;
my %h;
$h{div_sum($_) <=> $_}++ for 1..20000;
say "Perfect: $h{0}    Deficient: $h{-1}    Abundant: $h{1}";
