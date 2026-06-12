# 20240920 Perl programming solution

package Lindenmayer;

use strict;
use warnings;

sub new {
   my ($class, $rules) = @_;
   return bless { rules => $rules }, $class;
}

sub succ {
   my ($self, $current) = @_;
   my @result;
   foreach my $char (split //, $current) {
      exists $self->{rules}{$char} ? push @result, $self->{rules}{$char}
                                   : push @result, $char;
   }
   return join('', @result);
}

my $rabbits = Lindenmayer->new({ I => 'M', M => 'MI' });
print my $current = 'I', "\n";
for (1..5) { print $current = $rabbits->succ($current), "\n" }
