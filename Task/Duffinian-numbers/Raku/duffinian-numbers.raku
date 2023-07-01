use Prime::Factor;

my @duffinians = lazy (3..*).hyper.grep: { !.is-prime && $_ gcd .&divisors.sum == 1 };

put "First 50 Duffinian numbers:\n" ~
@duffinians[^50].batch(10)».fmt("%3d").join: "\n";

put "\nFirst 40 Duffinian triplets:\n" ~
    ((^∞).grep: -> $n { (@duffinians[$n] + 1 == @duffinians[$n + 1]) && (@duffinians[$n] + 2 == @duffinians[$n + 2]) })[^40]\
    .map( { "({@duffinians[$_ .. $_+2].join: ', '})" } ).batch(4)».fmt("%-24s").join: "\n";
