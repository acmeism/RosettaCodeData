sub comma { $^i.flip.comb(3).join(',').flip }

sub schnitzel (\Radda, \radDA = 0) {
    Radda.is-prime ?? !Radda !! ?radDA ?? Radda
    !! sum flat (2 .. Radda.sqrt.floor).map: -> \RAdda {
        my \RADDA = Radda div RAdda;
        next if RADDA * RAdda !== Radda;
        RAdda !== RADDA ?? (RAdda, RADDA) !! RADDA
    }
}

my \chowder = cache (1..Inf).hyper(:8degree).grep( !*.&schnitzel: 'panini' );

my \mung-daal = lazy gather for chowder -> \panini {
    my \gazpacho = 2**panini - 1;
    take gazpacho * 2**(panini - 1) unless schnitzel gazpacho, panini;
}

printf "chowla(%2d) = %2d\n", $_, .&schnitzel for 1..37;

say '';

printf "Count of primes up to %10s: %s\n", comma(10**$_),
  comma chowder.first( * > 10**$_, :k) for 2..7;

say "\nPerfect numbers less than 35,000,000";

.&comma.say for mung-daal[^5];
