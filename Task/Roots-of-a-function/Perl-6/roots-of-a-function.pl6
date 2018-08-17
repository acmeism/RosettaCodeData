sub f(\x) { x³ - 3*x² + 2*x }

my $start = -1;
my $stop = 3;
my $step = 0.001;

for $start, * + $step ... $stop -> $x {
    state $sign = 0;
    given f($x) {
        my $next = .sign;
        when 0.0 {
            say "Root found at $x";
        }
        when $sign and $next != $sign {
            say "Root found near $x";
        }
        NEXT $sign = $next;
    }
}
