package AbstractFoo;

use Moose::Role;

requires qw/frob baz/;

sub frob_the_baz {
    my $self = shift;
    $self->frob($self->baz());
}

1;
