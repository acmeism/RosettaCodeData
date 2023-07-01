# 20201101 added Perl programming solution

use strict;
use warnings;

use Data::Monad::Maybe;

sub safeReciprocal { ( $_[0] == 0 ) ? nothing : just(  1 /  $_[0] )   }

sub safeRoot       { ( $_[0] <  0 ) ? nothing : just( sqrt( $_[0] ) ) }

sub safeLog        { ( $_[0] <= 0 ) ? nothing : just( log ( $_[0] ) ) }

print join(' ', map {
   my $safeLogRootReciprocal = just($_)->flat_map( \&safeReciprocal )
                                       ->flat_map( \&safeRoot       )
                                       ->flat_map( \&safeLog        );
   $safeLogRootReciprocal->is_nothing ? "NaN" : $safeLogRootReciprocal->value;
} (-2, -1, -0.5, 0, exp (-1), 1, 2, exp(1), 3, 4, 5) ), "\n";
