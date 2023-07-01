use bigint try=>"GMP";
sub stream {
    my ($next, $safe, $prod, $cons, $z, $x) = @_;
    $x = $x->();
    sub {
        while (1) {
            my $y = $next->($z);
            if ($safe->($z, $y)) {
                $z = $prod->($z, $y);
                return $y;
            } else {
                $z = $cons->($z, $x->());
            }
        }
    }
}

sub extr {
    use integer;
    my ($q, $r, $s, $t) = @{shift()};
    my $x = shift;
    ($q * $x + $r) / ($s * $x + $t);
}

sub comp {
    my ($q, $r, $s, $t) = @{shift()};
    my ($u, $v, $w, $x) = @{shift()};
    [$q * $u + $r * $w,
     $q * $v + $r * $x,
     $s * $u + $t * $w,
     $s * $v + $t * $x];
}

my $pi_stream = stream
    sub { extr shift, 3 },
    sub { my ($z, $n) = @_; $n == extr $z, 4 },
    sub { my ($z, $n) = @_; comp([10, -10*$n, 0, 1], $z) },
    \&comp,
    [1, 0, 0, 1],
    sub { my $n = 0; sub { $n++; [$n, 4 * $n + 2, 0, 2 * $n + 1] } },
;
$|++;
print $pi_stream->(), '.';
print $pi_stream->() while 1;
