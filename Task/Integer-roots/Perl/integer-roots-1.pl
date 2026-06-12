use bigint;

sub integer_root {
    our($a,$b) = @_;
    our $a1 = $a - 1;
    my $c = 1;
    my $d = f($c);
    my $e = f($d);
    ($c, $d, $e) = ($d, $e, f($e)) until $c==$d || $c==$e;
    return $d < $e ? $d : $e;

    sub f { ($a1*$_[0]+$b/$_[0]**$a1)/$a }
}

print integer_root( 3, 8), "\n";
print integer_root( 3, 9), "\n";
print integer_root( 2, 2 * 100 ** 2000), "\n";
