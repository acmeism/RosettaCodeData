use v5.36;

package Zeckendorf;
use overload qw("" zstring + zadd - zsub ++ zinc -- zdec * zmul / zdiv ge zge);

sub new ($class, $value) {
    bless \$value, ref $class || $class;
}

sub zinc ($self, $, $) {
    local $_ = $$self;
    s/0$/1/ or s/(?:^|0)1$/10/;
    1 while s/(?:^|0)11/100/;
    $$self = $self->new( s/^0+\B//r )
}

sub zdec ($self, $, $) {
    local $_ = $$self;
    1 while s/100(?=0*$)/011/;
    s/1$/0/ || s/10$/01/;
    $$self = $self->new( s/^0+\B//r )
}

sub zadd ($self, $other, $) {
    my ($x, $y) = map $self->new($$_), $self, $other;
    $x++, $y-- while $$y;
    $x
}

sub zsub ($self, $other, $) {
    my ($x, $y) = map $self->new($$_), $self, $other;
    $x--, $y-- while $$y;
    $x
}

sub zmul ($self, $other, $) {
    my ($x, $y) = map $self->new($$_), $self, $other;
    my $product = Zeckendorf->new(0);
    $product = $product + $x, $y-- while $y;
    $product
}

sub zdiv ($self, $other, $) {
    my ($x, $y) = map $self->new($$_), $self, $other;
    my $quotient = Zeckendorf->new(0);
    $quotient++, $x = $x - $y while $x ge $y;
    $quotient
}

sub zge ($self, $other, $) {
    my $l; $l = length $$other if length $other > ($l = length $$self);
    0 x ($l - length $$self) . $$self ge 0 x ($l - length $$other) . $$other;
}

sub asdecimal ($self) {
    my($aa, $bb, $n) = (1, 1, 0);
    for ( reverse split '', $$self ) {
        $n += $bb * $_;
        ($aa, $bb) = ($bb, $aa + $bb);
    }
    $n
}

sub fromdecimal ($self, $value) {
    my $z = $self->new(0);
    $z++ for 1 .. $value;
    $z
}

sub zstring { ${ shift() } }

package main;

for ( split /\n/, <<END ) # test cases
  1 + 1
  10 + 10
  10100 + 1010
  10100 - 1010
  10100 * 1010
  100010 * 100101
  10100 / 1010
  101000 / 1000
  100001000001 / 100010
  100001000001 / 100101
END
  {
  my ($left, $op, $right) = split;
  my ($x, $y) = map Zeckendorf->new($_), $left, $right;
  my $answer =
    $op eq '+' ? $x + $y :
    $op eq '-' ? $x - $y :
    $op eq '*' ? $x * $y :
    $op eq '/' ? $x / $y :
    die "bad op <$op>";
    printf "%12s %s %-9s => %12s  in Zeckendorf\n", $x, $op, $y, $answer;
    printf "%12d %s %-9d => %12d  in decimal\n\n",
    $x->asdecimal, $op, $y->asdecimal, $answer->asdecimal;
  }
