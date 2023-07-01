use strict; use warnings;
require 5.014; # check HTTP::Tiny part of core
use HTTP::Tiny;

print( HTTP::Tiny->new()->get( 'http://rosettacode.org')->{content} );
