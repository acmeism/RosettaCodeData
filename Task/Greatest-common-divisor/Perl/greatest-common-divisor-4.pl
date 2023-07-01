# Fastest, takes multiple inputs
use Math::Prime::Util "gcd";
$gcd = gcd(49865, 69811);

# In CORE.  Slowest, takes multiple inputs, result is a Math::BigInt unless converted
use Math::BigInt;
$gcd = Math::BigInt::bgcd(49865, 69811)->numify;

# Result is a Math::Pari object unless converted
use Math::Pari "gcd";
$gcd = gcd(49865, 69811)->pari2iv
