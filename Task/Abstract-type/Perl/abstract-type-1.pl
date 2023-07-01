package AbstractFoo;

use strict;

sub frob { die "abstract" }
sub baz { die "abstract" }

sub frob_the_baz {
    my $self = shift;
    $self->frob($self->baz());
}


1;
