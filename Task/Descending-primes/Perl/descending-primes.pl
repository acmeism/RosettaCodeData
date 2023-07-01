use strict;
use warnings;
use ntheory 'is_prime';

print join( '',
        sort
        map { sprintf '%9d', $_ }
        grep /./ && is_prime $_,
        glob join '', map "{$_,}", reverse 1..9
      ) =~ s/.{45}\K/\n/gr;
