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

sub abbrev ($n) {
   $n.chars > 50 ??
   $n.substr(0,10) ~ "...({$n.chars - 20} digits omitted)..." ~ $n.substr(* - 10) !!
   $n
}

my @primes = (2..*).grep: *.is-prime;

my $start = 3000;

for ^@primes.first( * > 29, :k ) -> $p {
    put join "\n", "\nFirst 25, and {$start}th through {$start+2}nd {@primes[$p]}-smooth numbers:",
    $(smooth-numbers(|@primes[0..$p])[^25]),
    $(smooth-numbers(|@primes[0..$p])[$start - 1 .. $start + 1]».&abbrev);
}

$start = 30000;

for 503, 509, 521 -> $p {
    my $i = @primes.first( * == $p, :k );
    put "\n{$start}th through {$start+19}th {@primes[$i]}-smooth numbers:\n" ~
    smooth-numbers(|@primes[0..$i])[$start - 1 .. $start + 18];
}
