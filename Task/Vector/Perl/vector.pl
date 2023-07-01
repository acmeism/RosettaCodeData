use v5.36;

package Vector;
use Moose;
use overload '+'  => \&add,
             '-'  => \&sub,
             '*'  => \&mul,
             '/'  => \&div,
             '""' => \&stringify;

has 'x' => (is =>'rw', isa => 'Num', required => 1);
has 'y' => (is =>'rw', isa => 'Num', required => 1);

sub add ($a, $b, $) { Vector->new( x => $a->x + $b->x, y => $a->y + $b->y) }
sub sub ($a, $b, $) { Vector->new( x => $a->x - $b->x, y => $a->y - $b->y) }
sub mul ($a, $b, $) { Vector->new( x => $a->x * $b,    y => $a->y * $b)    }
sub div ($a, $b, $) { Vector->new( x => $a->x / $b,    y => $a->y / $b)    }
sub stringify ($self, $, $) { '(' . $self->x . ',' . $self->y . ')' }

package main;

my $a = Vector->new(x => 5, y => 7);
my $b = Vector->new(x => 2, y => 3);
say "a:    $a";
say "b:    $b";
say "a+b:  ",$a+$b;
say "a-b:  ",$a-$b;
say "a*11: ",$a*11;
say "a/2:  ",$a/2;
