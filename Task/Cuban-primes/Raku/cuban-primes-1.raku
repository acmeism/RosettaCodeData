use Lingua::EN::Numbers;
use ntheory:from<Perl5> <:all>;

my @cubans = lazy (1..Inf).map({ ($_+1)³ - .³ }).grep: *.&is_prime;

put @cubans[^200]».&comma».fmt("%9s").rotor(10).join: "\n";

put '';

put @cubans[99_999].&comma; # zero indexed
