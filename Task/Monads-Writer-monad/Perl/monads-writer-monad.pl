# 20200704 added Perl programming solution

package Writer;

use strict;
use warnings;

sub new {
   my ($class, $value, $log) = @_;
   return bless [ $value => $log ], $class;
}

sub Bind {
   my ($self, $code) = @_;
   my ($value, $log) = @$self;
   my $n = $code->($value);
   return Writer->new( @$n[0], $log.@$n[1] );
}

sub Unit { Writer->new($_[0], sprintf("%-17s: %.12f\n",$_[1],$_[0])) }

sub root { Unit sqrt($_[0]), "Took square root" }

sub addOne { Unit $_[0]+1, "Added one" }

sub half { Unit $_[0]/2, "Divided by two" }

print Unit(5, "Initial value")->Bind(\&root)->Bind(\&addOne)->Bind(\&half)->[1];
