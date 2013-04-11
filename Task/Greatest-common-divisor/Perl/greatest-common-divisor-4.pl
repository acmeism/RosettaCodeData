use Benchmark qw(cmpthese);

my $u = 40902;
my $v = 24140;
cmpthese(-5, {
  'gcd' => sub { gcd($u, $v); },
  'gcd_iter' => sub { gcd_iter($u, $v); },
  'gcd_bin' => sub { gcd_bin($u, $v); },
});
