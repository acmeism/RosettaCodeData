use 5.010_000;

package Delegate::Protocol
use Moose::Role;
# All methods in the Protocol is optional
#optional  'thing';
# If we wanted to have a required method, we would state:
# requires 'required_method';
#

package Delegate::NoThing;
use Moose;
with 'Delegate::Protocol';

package Delegate;
use Moose;

#  The we confirm to Delegate::Protocol
with 'Delegate::Protocol';
sub thing { 'delegate implementation' };

package Delegator;
use Moose;

has delegate => (
     is      => 'rw',
    does => 'Delegate::Protocol', # Moose insures that the delegate confirms to the protocol.
   predicate => 'hasDelegate'
);

sub operation {

    my ($self) = @_;
    if( $self->hasDelegate  && $self->delegate->can('thing') ){
        return $self->delegate->thing() . $postfix; # we are know that delegate has thing.
    } else {
        return 'default implementation';
   }
};

package main;
use strict;

# No delegate
my $delegator = Delegator->new();
$delegator->operation eq 'default implementation' or die;

# With a delegate that does not implement "thing"
$delegator->delegate(  Delegate::NoThing->new );
$delegator->operation eq 'default implementation' or die;

# With delegate that implements "thing"
$delegator->delegate(  Delegate->new );
$delegator->operation eq 'delegate implementation' or die;
