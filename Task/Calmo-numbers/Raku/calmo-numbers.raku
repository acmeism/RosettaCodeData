use Prime::Factor;
use List::Divvy;

my $upto = 1e3;

my @found = (2..Inf).hyper.grep({
    (so my @d = .&proper-divisors(:s)) &&
    (@d.elems %% 3) &&
    (all @d.batch(3)».sum».is-prime)
}).&upto($upto);

put "{+@found} found before $upto using sums of proper-divisors:\n" ~
@found.batch(10)».fmt("%4d").join: "\n";

@found = (2..Inf).hyper.grep({
    (so my @d = .&proper-divisors(:s).&after: 1) &&
    (@d.elems %% 3) &&
    (all @d.batch(3)».sum».is-prime)
}).&upto($upto);

put "\n{+@found} found before $upto using sums of some bizarre\nbespoke definition for divisors:\n" ~
@found.batch(10)».fmt("%4d").join: "\n";
