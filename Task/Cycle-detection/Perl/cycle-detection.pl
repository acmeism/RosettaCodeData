use utf8;

sub cyclical_function { ($_[0] * $_[0] + 1) % 255 }

sub brent {
    my($f, $x0) = @_;
    my $power = 1;
    my $λ = 1;
    my $tortoise = $x0;
    my $hare = &$f($x0);
    while ($tortoise != $hare) {
        if ($power == $λ) {
            $tortoise = $hare;
            $power *= 2;
            $λ = 0;
        }
        $hare = &$f($hare);
        $λ += 1;
    }

    my $μ = 0;
    $tortoise = $hare = $x0;
    $hare = &$f($hare) for 0..$λ-1;

    while ($tortoise != $hare) {
        $tortoise = &$f($tortoise);
        $hare = &$f($hare);
        $μ += 1;
    }
    return $λ, $μ;
}

my ( $l, $s ) = brent( \&cyclical_function, 3 );

sub show_range {
    my($start,$stop) = @_;
    my $result;
    my $x = 3;
    for my $n (0..$stop) {
        $result .= "$x " if $n >= $start;
        $x = cyclical_function($x);
    }
    $result;
}

print show_range(0,19) . "\n";
print "Cycle length $l\n";
print "Cycle start index $s\n";
print show_range($s,$s+$l-1) . "\n";
