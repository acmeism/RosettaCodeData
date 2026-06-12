use Lingua::EN::Numbers;
use List::Divvy;

my @factorial = 1, |[\*] 1..*;
my @Erdős = ^∞ .grep: { .is-prime and none($_ «-« @factorial.&upto: $_).is-prime }

put "Erdős primes < 2500:\n" ~ @Erdős.&before(2500)».&comma.batch(8)».fmt("%5s").join: "\n";
put "\nThe largest Erdős prime less than {comma 1e6.Int} is {comma .[*-1]} in {.&ordinal-digit} position."
  given @Erdős.&before(1e6);
