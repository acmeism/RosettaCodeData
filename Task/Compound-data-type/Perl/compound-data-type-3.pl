package Point;

use strict;
use base 'Class::Struct'
    x => '$',
    y => '$',
;

my $point = Point->new(x => 3, y => 8);
