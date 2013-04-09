use strict;

package Delegator;
sub new {
   bless {}
}
sub operation {
   my ($self) = @_;
   if (defined $self->{delegate} && $self->{delegate}->can('thing')) {
      $self->{delegate}->thing;
   } else {
      'default implementation';
   }
}
1;

package Delegate;
sub new {
   bless {};
}
sub thing {
   'delegate implementation'
}
1;


package main;
# No delegate
my $a = Delegator->new;
$a->operation eq 'default implementation' or die;

# With a delegate that does not implement "thing"
$a->{delegate} = 'A delegate may be any object';
$a->operation eq 'default implementation' or die;

# With delegate that implements "thing"
$a->{delegate} = Delegate->new;
$a->operation eq 'delegate implementation' or die;
