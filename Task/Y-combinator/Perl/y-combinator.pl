my $Y = sub { my ($f) = @_; sub {my ($x) = @_; $x->($x)}->(sub {my ($y) = @_; $f->(sub {$y->($y)->(@_)})})};
my $fac = sub {my ($f) = @_; sub {my ($n) = @_; $n < 2 ? 1 : $n * $f->($n-1)}};
print join(' ', map {$Y->($fac)->($_)} 0..9), "\n";
my $fib = sub {my ($f) = @_; sub {my ($n) = @_; $n == 0 ? 0 : $n == 1 ? 1 : $f->($n-1) + $f->($n-2)}};
print join(' ', map {$Y->($fib)->($_)} 0..9), "\n";
