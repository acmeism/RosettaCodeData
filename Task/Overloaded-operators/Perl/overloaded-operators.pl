use v5.36;

package Ones;
use overload qw("" asstring + add - subtract * multiply / divide);

sub new       ( $class, $value ) { bless \('1' x $value), ref $class || $class  }
sub asstring  ($self, $other, $) { $$self                                       }
sub asdecimal ($self, $other, $) { length $$self                                }
sub add       ($self, $other, $) { bless \($$self . $$other),         ref $self }
sub subtract  ($self, $other, $) { bless \($$self =~ s/$$other//r),   ref $self }
sub multiply  ($self, $other, $) { bless \($$self =~ s/1/$$other/gr), ref $self }
sub divide    ($self, $other, $) { $self->new( $$self =~ s/$$other/$$other/g )  }

package main;

my($x,$y,$z) = ( Ones->new(15), Ones->new(4) );
$z = $x + $y; say "$x + $y = $z";
$z = $x - $y; say "$x - $y = $z";
$z = $x * $y; say "$x * $y = $z";
$z = $x / $y; say "$x / $y = $z";
