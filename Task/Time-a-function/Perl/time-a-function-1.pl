use Benchmark;
use Memoize;

sub fac1 {
    my $n = shift;
    return $n == 0 ? 1 : $n * fac1($n - 1);
}
sub fac2 {
    my $n = shift;
    return $n == 0 ? 1 : $n * fac2($n - 1);
}
memoize('fac2');

my $result = timethese(100000, {
    'fac1' => sub { fac1(50) },
    'fac2' => sub { fac2(50) },
});
Benchmark::cmpthese($result);
