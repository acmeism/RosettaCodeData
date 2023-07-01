use ntheory:from<Perl5> <is_prime>;
use Lingua::EN::Numbers;

sub is-unprimeable (\n) {
     return False if n.&is_prime;
     my \chrs = n.chars;
     for ^chrs -> \place {
         my \pow = 10**(chrs - place - 1);
         my \this = n.substr(place, 1) × pow;
         ^10 .map: -> \dgt {
             next if this == dgt;
             return False if is_prime(n - this + dgt × pow)
         }
     }
     True
}

my @ups = lazy ^∞ .grep: { .&is-unprimeable };

say "First 35 unprimeables:\n" ~ @ups[^35];

say "\n{ordinal-digit(600, :u)} unprimeable: " ~ comma( @ups[599] ) ~ "\n";

^10 .map: -> \n {
    print "First unprimeable that ends with {n}: " ~
    sprintf "%9s\n", comma (n, *+10 … *).race.first: { .&is-unprimeable }
}
