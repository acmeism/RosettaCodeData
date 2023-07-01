use strict;
use warnings;
use ntheory 'is_prime';

print join( '',
        map { sprintf '%10d', $_ }
        sort { $a <=> $b }
        grep /./ && is_prime $_,
        glob join '', map "{$_,}", 1..9
      ) =~ s/.{50}\K/\n/gr;
