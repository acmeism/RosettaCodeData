#  Legendre operator (𝑛│𝑝)
sub infix:<│> (Int \𝑛, Int \𝑝 where 𝑝.is-prime && (𝑝 != 2)) {
    given 𝑛.expmod( (𝑝-1) div 2, 𝑝 ) {
        when 0  {  0 }
        when 1  {  1 }
        default { -1 }
    }
}

sub tonelli-shanks ( \𝑛, \𝑝 where (𝑛│𝑝) > 0 ) {
    my $𝑄 = 𝑝 - 1;
    my $𝑆 = 0;
    $𝑄 +>= 1 and $𝑆++ while $𝑄 %% 2;
    return 𝑛.expmod((𝑝+1) div 4, 𝑝) if $𝑆 == 1;
    my $𝑐 = ((2..𝑝).first: (*│𝑝) < 0).expmod($𝑄, 𝑝);
    my $𝑅 = 𝑛.expmod( ($𝑄+1) +> 1, 𝑝 );
    my $𝑡 = 𝑛.expmod( $𝑄, 𝑝 );
    while ($𝑡-1) % 𝑝 {
        my $b;
        my $𝑡2 = $𝑡² % 𝑝;
        for 1 .. $𝑆 {
            if ($𝑡2-1) %% 𝑝 {
                $b = $𝑐.expmod(1 +< ($𝑆-1-$_), 𝑝);
                $𝑆 = $_;
                last;
            }
            $𝑡2 = $𝑡2² % 𝑝;
        }
        $𝑅 = ($𝑅 * $b) % 𝑝;
        $𝑐 = $b² % 𝑝;
        $𝑡 = ($𝑡 * $𝑐) % 𝑝;
    }
    $𝑅;
}

my @tests = (
    (10, 13),
    (56, 101),
    (1030, 10009),
    (1032, 10009),
    (44402, 100049),
    (665820697, 1000000009),
    (881398088036, 1000000000039),
    (41660815127637347468140745042827704103445750172002,
      100000000000000000000000000000000000000000000000577)
);

 for @tests -> ($n, $p) {
    try my $t = tonelli-shanks($n, $p);
    say "No solution for ({$n}, {$p})." and next if !$t or ($t² - $n) % $p;
    say "Roots of $n are ($t, {$p-$t}) mod $p";
}
