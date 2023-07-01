use bigint; say 42->bmodinv(2017);
# or
use Math::ModInt qw/mod/;  say mod(42, 2017)->inverse->residue;
# or
use Math::Pari qw/PARI lift/; say lift PARI "Mod(1/42,2017)";
# or
use Math::GMP qw/:constant/; say 42->bmodinv(2017);
# or
use ntheory qw/invmod/; say invmod(42, 2017);
