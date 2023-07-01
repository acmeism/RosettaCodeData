#!/usr/bin/env perl
use strict;
use warnings;

sub bottles() { sprintf qq{%s bottle%s of beer}
               , $_ || 'No'
               , $_==1 ? '' : 's';
               }
sub store() { $_=99; qq{Go to the store, buy some more...\n}; }
sub wall() { qq{ on the wall\n} }
sub take() { $_-- ? qq{Take one down, pass it around\n} : store }
do { print bottles, wall
         , bottles, qq{\n}
         , take
         , bottles, qq{\n\n}
   } for reverse 0..99;
