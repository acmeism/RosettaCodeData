use ntheory qw/Pi/;
say Pi(10000);

use Math::Pari qw/setprecision Pi/;
setprecision(10000);
say Pi;

use Math::MPFR;
my $pi = Math::MPFR->new();
Math::MPFR::Rmpfr_set_prec($pi, int(10000 * 3.322)+40);
Math::MPFR::Rmpfr_const_pi($pi, 0);
say Math::MPFR::Rmpfr_get_str($pi, 10, 10000, 0);

use Math::BigFloat try=>"GMP";    # Slow without Math::BigInt::GMP installed
say Math::BigFloat::bpi(10000);   # For over ~2k digits, slower than AGM

use Math::Big qw/pi/;    # Very slow
say pi(10000);
