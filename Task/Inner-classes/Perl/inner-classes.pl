# 20241004 Perl programming solution

use strict;
use warnings;

package OuterClass;
use Moose;
   {
       package InnerClass;
       use Moose;

       has 'inner_attribute' => (
          is  => 'rw',
          isa => 'Str',
       );

       sub inner_method {
          my $self = shift;
          return "Inner method called with attribute: " . $self->inner_attribute
       }
   }

has 'outer_attribute' => (
   is  => 'rw',
   isa => 'Str',
);

has 'inner_object' => (
   is      => 'rw',
   isa     => 'InnerClass',
   default => sub { InnerClass->new(inner_attribute => 'default inner value') },
);

sub outer_method1 {
    my $self = shift;
    return "Outer method called with attribute: " . $self->outer_attribute . "\n" . $self->inner_object->inner_method;
}

sub outer_method2 {
    my ($self, $data) = @_;
    my $inner =  InnerClass->new(inner_attribute => $data);
    return $inner->inner_method;
}

1;

package main;

my $outer = OuterClass->new(outer_attribute => 'outer value');
print $outer->outer_method1, "\n";
print $outer->outer_method2('custom value'), "\n";

my $inner = InnerClass->new(inner_attribute => 'direct access value');
print $inner->inner_method, "\n";
