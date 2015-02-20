use Benchmark qw(cmpthese);
use Math::BigInt;
use Math::Pari;
use Math::Prime::Util;

my $u = 40902;
my $v = 24140;
cmpthese(-5, {
  'gcd_rec' => sub { gcd($u, $v); },
  'gcd_iter' => sub { gcd_iter($u, $v); },
  'gcd_bin' => sub { gcd_bin($u, $v); },
  'gcd_bigint' => sub { Math::BigInt::bgcd($u,$v)->numify(); },
  'gcd_pari' => sub { Math::Pari::gcd($u,$v)->pari2iv(); },
  'gcd_mpu' => sub { Math::Prime::Util::gcd($u,$v); },
});
