sub smooth-numbers (*@list) {
    cache my \Smooth := gather {
        my %i = (flat @list) Z=> (Smooth.iterator for ^@list);
        my %n = (flat @list) Z=> 1 xx *;

        loop {
            take my $n := %n{*}.min;

            for @list -> \k {
                %n{k} = %i{k}.pull-one * k if %n{k} == $n;
            }
        }
    }
}

# Testing various smooth numbers

for   'OEIS: A092506 - 2 + Fermat primes:',        (2),        1,  6,
    "\nOEIS: A000668 - Mersenne primes:",          (2),       -1, 10,
    "\nOEIS: A005109 - Pierpont primes 1st:",      (2,3),      1, 20,
    "\nOEIS: A005105 - Pierpont primes 2nd:",      (2,3),     -1, 20,
    "\nOEIS: A077497:",                            (2,5),      1, 20,
    "\nOEIS: A077313:",                            (2,5),     -1, 20,
    "\nOEIS: A002200 - (\"Hamming\" primes 1st):", (2,3,5),    1, 20,
    "\nOEIS: A293194 - (\"Hamming\" primes 2nd):", (2,3,5),   -1, 20,
    "\nOEIS: A077498:",                            (2,7),      1, 20,
    "\nOEIS: A077314:",                            (2,7),     -1, 20,
    "\nOEIS: A174144 - (\"Humble\" primes 1st):",  (2,3,5,7),  1, 20,
    "\nOEIS: A347977 - (\"Humble\" primes 2nd):",  (2,3,5,7), -1, 20,
    "\nOEIS: A077499:",                            (2,11),     1, 20,
    "\nOEIS: A077315:",                            (2,11),    -1, 20,
    "\nOEIS: A173236:",                            (2,13),     1, 20,
    "\nOEIS: A173062:",                            (2,13),    -1, 20

  -> $title, $primes, $add, $count {

      say "$title smooth \{$primes\} {$add > 0 ?? '+' !! '-'} 1 ";
      put smooth-numbers(|$primes).map( * + $add ).grep( *.is-prime )[^$count]
}
