sub is-narcissistic(Int $n) { $n == [+] $n.comb »**» $n.chars }
my @N = lazy (0..∞).hyper.grep: *.&is-narcissistic;
@N[^25].join(' ').say;
