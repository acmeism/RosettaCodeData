use HTTP::UserAgent;
use Gumbo;

my $table = parse-html(HTTP::UserAgent.new.get('https://www.mersenne.org/primes/').content, :TAG<table>);

say 'All known Mersenne primes as of ', Date(now);

say 'M', ++$, ": 2$_ - 1"
  for $table[1]».[*][0][*].comb(/'perfect'\d+/)».subst(/\D/, '',:g)
  .trans([<0123456789>.comb] => [<⁰¹²³⁴⁵⁶⁷⁸⁹>.comb]).words;
