use ntheory qw/divisor_sum/;
my %h;
$h{divisor_sum($_)-$_ <=> $_}++ for 1..20000;
say "Perfect: $h{0}    Deficient: $h{-1}    Abundant: $h{1}";
