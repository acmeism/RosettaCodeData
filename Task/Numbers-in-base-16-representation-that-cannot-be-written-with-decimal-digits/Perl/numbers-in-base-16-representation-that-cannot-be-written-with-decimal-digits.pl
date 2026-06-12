use strict;
use warnings;

print join( ' ', grep sprintf("%x", $_) !~ /[0-9]/, 1 .. 500 ) =~ s/.{71}\K /\n/gr, "\n";
