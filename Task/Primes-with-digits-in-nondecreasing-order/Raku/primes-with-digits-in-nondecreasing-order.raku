my $range = ^1000;

for flat 2..10, 17, 27, 31 -> $base {
   say "\nBase $base: {+$_} non-decending primes between $range.minmax.map( *.base: $base ).join(' and '):\n{
      .batch(20)».fmt("%{.tail.chars}s").join: "\n" }"
       given $range.grep( *.is-prime ).map( *.base: $base ).grep: { [le] .comb }
}
