use Math::ModInt qw(mod);
use Math::ModInt::ChineseRemainder qw(cr_combine);
say cr_combine(mod(2,3),mod(3,5),mod(2,7));
