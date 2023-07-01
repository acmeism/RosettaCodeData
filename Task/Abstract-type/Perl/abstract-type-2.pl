package AbstractFoo;

use strict;

sub frob { ... }
sub baz { ... }

sub frob_the_baz {
    my $self = shift;
    $self->frob($self->baz());
}

1;
