use Prime::Factor;
use Lingua::EN::Numbers;

my @arithmetic = lazy (1..∞).hyper.grep: { my @div = .&divisors; @div.sum %% @div }

say "The first { .Int.&cardinal } arithmetic numbers:\n", @arithmetic[^$_].batch(10)».fmt("%{.chars}d").join: "\n" given 1e2;

for 1e3, 1e4, 1e5, 1e6 {
    say "\nThe { .Int.&ordinal }: { comma @arithmetic[$_-1] }";
    say "Composite arithmetic numbers ≤ { comma @arithmetic[$_-1] }: { comma +@arithmetic[^$_].grep({!.is-prime}) - 1 }";
}
