use strict;
use warnings;

for ( -2**31, -2**31+1, -2, -1, 0, 1, 2, 2**31-2, 2**31-1 ) {
   printf "$_ -> %d\n", $_ == 0 ? 0 : ~$_+1
}
