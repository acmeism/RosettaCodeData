use strict;
use warnings;
use feature 'say';

{
package Point;
use Class::Struct;
struct( x => '$', y => '$',);
sub print { '(' . $_->x . ', ' . $_->y . ')' }
}

sub ccw {
    my($a, $b, $c) = @_;
    ($b->x - $a->x)*($c->y - $a->y) - ($b->y - $a->y)*($c->x - $a->x);
}

sub tangent {
    my($a, $b) = @_;
    my $opp = $b->x - $a->x;
    my $adj = $b->y - $a->y;
    $adj != 0 ? $opp / $adj : 1E99;
}

sub graham_scan {
    our @coords; local *coords = shift;
    my @sp = sort { $a->y <=> $b->y or $a->x <=> $b->x } map { Point->new( x => $_->[0], y => $_->[1] ) } @coords;

    # need at least 3 points to make a hull
    return @sp if @sp < 3;

    # first point on hull is minimum y point
    my @h  = shift @sp;

    # re-sort the points by angle, secondary on x (classic Schwartzian)
    @sp =
    map { $sp[$_->[0]] }
    sort { $b->[1] <=> $a->[1] or $a->[2] <=> $b->[2] }
    map { [$_, tangent($h[0], $sp[$_]), $sp[$_]->x] }
    0..$#sp;

    # first point of re-sorted list is guaranteed to be on hull
    push @h, shift @sp;

    # check through the remaining list making sure that there is always a positive angle
    for my $point (@sp) {
        if (ccw( @h[-2,-1], $point ) >= 0) {
            push @h, $point;
        } else {
            pop @h;
            redo;
        }
    }
    @h
}

my @hull_1 = graham_scan(
   [[16, 3], [12,17], [ 0, 6], [-4,-6], [16, 6], [16,-7], [16,-3],
    [17,-4], [ 5,19], [19,-8], [ 3,16], [12,13], [ 3,-4], [17, 5],
    [-3,15], [-3,-9], [ 0,11], [-9,-3], [-4,-2], [12,10]]
  );

my @hull_2 = graham_scan(
   [[16, 3], [12,17], [ 0, 6], [-4,-6], [16, 6], [16,-7], [16,-3],
    [17,-4], [ 5,19], [19,-8], [ 3,16], [12,13], [ 3,-4], [17, 5],
    [-3,15], [-3,-9], [ 0,11], [-9,-3], [-4,-2], [12,10], [14,-9], [1,-9]]
  );

my $list = join ' ', map { Point::print($_) } @hull_1;
say "Convex Hull (@{[scalar @hull_1]} points): [$list]";
   $list = join ' ', map { Point::print($_) } @hull_2;
say "Convex Hull (@{[scalar @hull_2]} points): [$list]";
