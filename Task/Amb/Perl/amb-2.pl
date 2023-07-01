#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';
use re 'eval';

sub amb :prototype($@) {
    my $var = shift;
    join ' || ', map { "(?{ $var = '$_' })" } @_;
}

sub joins {
    substr(shift,-1,1) eq substr(shift,0,1)
}

my ($a,$b,$c,$d);
'' =~ m/
    (??{  amb '$a', qw[the that a]           })
    (??{  amb '$b', qw[frog elephant thing]  })
    (??{  amb '$c', qw[walked treaded grows] })
    (??{  amb '$d', qw[slowly quickly]       })
    (?(?{ joins($b, $c)                      })|(*FAIL))
    (?(?{ joins($a, $b)                      })|(*FAIL))
    (?(?{ joins($c, $d)                      })|(*FAIL))
    (?{   say "$a $b $c $d"                  })
/x;
