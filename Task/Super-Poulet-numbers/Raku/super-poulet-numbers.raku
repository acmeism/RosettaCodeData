use Prime::Factor;
use Lingua::EN::Numbers;

my @poulet = lazy (2..*).hyper(:2000batch).grep: { !.is-prime && (1 == expmod 2, $_ - 1, $_) }
my @super-poulet = @poulet.grep: { all .&divisors.skip(1).map: { 2 == expmod 2, $_, $_ } }

say "First 20 super-Poulet numbers:\n" ~ @super-poulet[^20].gist;

for 1e6.Int, 1e7.Int -> $threshold {
    say "\nIndex and value of first super-Poulet greater than {$threshold.&cardinal}:";
    my $index = @super-poulet.first: * > $threshold, :k;
    say "{(1+$index).&ordinal-digit} super-Poulet number == " ~ @super-poulet[$index].&comma;
}
