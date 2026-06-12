use Prime::Factor;
use Lingua::EN::Numbers;

my \𝜑 = 0, |(1..*).hyper.map: -> \t { t × [×] t.&prime-factors.unique.map: { 1 - 1/$_ } }

sub pair-count (\n) {  n × (n - 1) / 2 + 1 - sum 𝜑[1..n] }

say "Number of pairs with common factors - first one hundred terms:\n"
    ~ (1..100).map(&pair-count).batch(10)».&comma».fmt("%6s").join("\n") ~ "\n";

for ^7 { say (my $i = 10 ** $_).&ordinal.tc.fmt("%22s term: ") ~ $i.&pair-count.&comma }
