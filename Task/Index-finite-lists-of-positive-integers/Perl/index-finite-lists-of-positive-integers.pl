use bigint;
use ntheory qw(fromdigits todigitstring);
use feature 'say';

sub rank   { join   '', fromdigits(join('a',@_), 11) }
sub unrank { split 'a', todigitstring(@_[0],     11) }

say join ' ', @n = qw<12 11 0 7 9 15 15 5 7 13 5 5>;
say $n = rank(@n);
say join ' ', unrank $n;
