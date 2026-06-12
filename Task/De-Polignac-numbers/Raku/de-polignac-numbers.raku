use List::Divvy;
use Lingua::EN::Numbers;
constant @po2 = (1..∞).map: 2 ** *;
my @dePolignac = lazy 1, |(2..∞).hyper.map(* × 2 + 1).grep: -> $n { all @po2.&upto($n).map: { !is-prime $n - $_ } };

say "First fifty de Polignac numbers:\n" ~ @dePolignac[^50]».&comma».fmt("%5s").batch(10).join: "\n";
say "\nOne thousandth: " ~ comma @dePolignac[999];
say "\nTen thousandth: " ~ comma @dePolignac[9999];
