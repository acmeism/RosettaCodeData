use ntheory qw(pn_primorial);

say "First ten primorials: ", join ", ", map { pn_primorial($_) } 0..9;

say "primorial(10^$_) has ".(length pn_primorial(10**$_))." digits" for 1..6;
