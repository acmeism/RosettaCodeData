package AbstractFoo;

use Role::Tiny;

requires qw/frob baz/;

sub frob_the_baz {
    my $self = shift;
    $self->frob($self->baz());
}

1;
