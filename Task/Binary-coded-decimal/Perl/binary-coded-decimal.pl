# 20240921 Perl programming solution

use strict;
use warnings;
use Math::BigInt;

package Bcd64;

sub new {
   my ($class, $bits) = @_;
   return bless { bits => Math::BigInt->new($bits) }, $class;
}

sub add {
   my ($self, $other) = @_;
   my $t1 = $self->{bits} + Math::BigInt->new('0x0666666666666666');
   my $t2 = ($t1 + $other->{bits}) % Math::BigInt->new('0x10000000000000000');
   my $t3 = $t1 ^ $other->{bits};
   my $t4 = (~($t2 ^ $t3)) & Math::BigInt->new('0x1111111111111110');
   my $t5 = ($t4 >> 2) | ($t4 >> 3);
   return Bcd64->new($t2 - $t5);
}

sub negate {
   my ($self) = @_;
   my $t1 = Math::BigInt->new('0x10000000000000000') - $self->{bits};
   my $t2 = ($t1 + Math::BigInt->new('0xFFFFFFFFFFFFFFFF')) % Math::BigInt->new('0x10000000000000000');
   my $t3 = $t2 ^ 1;
   my $t4 = (~($t2 ^ $t3)) & Math::BigInt->new('0x1111111111111110');
   my $t5 = ($t4 >> 2) | ($t4 >> 3);
   return Bcd64->new($t1 - $t5);
}

sub minus {
   my ($self, $other) = @_;
   return $self->add($other->negate());
}

sub bits {
   my ($self) = @_;
   return sprintf("0x%016X", $self->{bits}->bstr());
}

my ($one, $n19, $n30, $n99) = map { Bcd64->new($_) } (0x01, 0x19, 0x30, 0x99);

print $n19->add($one)->bits(), "\n";
print $n30->minus($one)->bits(), "\n";
print $n99->add($one)->bits(), "\n";
