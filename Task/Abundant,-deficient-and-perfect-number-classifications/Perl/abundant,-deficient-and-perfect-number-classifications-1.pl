use ntheory qw/divisor_sum/;
my @type = <Perfect Abundant Deficient>;
say join "\n", map { sprintf "%2d %s", $_, $type[divisor_sum($_)-$_ <=> $_] } 1..12;
my %h;
$h{divisor_sum($_)-$_ <=> $_}++ for 1..20000;
say "Perfect: $h{0}    Deficient: $h{-1}    Abundant: $h{1}";
