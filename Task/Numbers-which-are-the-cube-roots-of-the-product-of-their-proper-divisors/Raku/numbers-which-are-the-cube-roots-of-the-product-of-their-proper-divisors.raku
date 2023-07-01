use Prime::Factor;
use Lingua::EN::Numbers;
my @cube-div = lazy 1, |(2..∞).hyper.grep: { .³ == [×] .&proper-divisors }

put "First 50 numbers which are the cube roots of the products of their proper divisors:\n" ~
  @cube-div[^50]».fmt("%3d").batch(10).join: "\n";

printf "\n%16s: %s\n", .Int.&ordinal.tc, comma @cube-div[$_ - 1] for 5e2, 5e3, 5e4;
