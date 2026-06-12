# 20240930 Perl programming solution

use strict;
use warnings;

package Vector2 {
   sub new {
      my ($class, %args) = @_;
      return bless \%args, $class;
   }

   sub dot {
      my ($self, $other) = @_;
      return $self->{x} * $other->{x} + $self->{y} * $other->{y};
   }
}

package Projection {
   sub new {
      my ($class, %args) = @_;
      return bless \%args, $class;
   }
}

sub get_axes {
   my ($poly) = @_;
   my @axes;

   push @$poly, $poly->[0];
   for my $i (0 .. @$poly - 2) {
      my $vector1 = Vector2->new(x => $poly->[$i][0], y => $poly->[$i][1]);
      my $vector2 = Vector2->new(x => $poly->[$i + 1][0], y => $poly->[$i + 1][1]);
      my $edge = Vector2->new(
         x => $vector1->{x} - $vector2->{x},
         y => $vector1->{y} - $vector2->{y}
      );
      push @axes, Vector2->new(x => -$edge->{y}, y => $edge->{x});
   }
   return @axes;
}

sub project_onto_axis {
   my ($poly, $axis) = @_;

   my $vertex0 = $poly->[0];
   my $vector0 = Vector2->new(x => $vertex0->[0], y => $vertex0->[1]);
   my ($min, $max) = ($axis->dot($vector0), $axis->dot($vector0));

   foreach my $vertex (@$poly) {
      my $vector = Vector2->new(x => $vertex->[0], y => $vertex->[1]);
      my $projection = $axis->dot($vector);

      if ($projection < $min) { $min = $projection }
      if ($projection > $max) { $max = $projection }
   }
   return Projection->new(min => $min, max => $max);
}

sub projections_overlap {
   my ($proj1, $proj2) = @_;
   return !($proj1->{max} < $proj2->{min} || $proj2->{max} < $proj1->{min});
}

sub polygons_overlap {
   my ($poly1, $poly2) = @_;
   my @axes1 = get_axes($poly1);
   my @axes2 = get_axes($poly2);
   my @all_axes = (@axes1, @axes2);

   foreach my $axis (@all_axes) {
      my ($proj1, $proj2) = (project_onto_axis($poly1, $axis), project_onto_axis($poly2, $axis));
      return 0 unless projections_overlap($proj1, $proj2);
   }
   return 1;
}

my @poly1 = ([0, 0], [0, 2], [1, 4], [2, 2], [2, 0]);
my @poly2 = ([4, 0], [4, 2], [5, 4], [6, 2], [6, 0]);
my @poly3 = ([1, 0], [1, 2], [5, 4], [9, 2], [9, 0]);

print "poly1 = ", join(' ', map { "($_->[0] $_->[1])" } @poly1), "\n";
print "poly2 = ", join(' ', map { "($_->[0] $_->[1])" } @poly2), "\n";
print "poly3 = ", join(' ', map { "($_->[0] $_->[1])" } @poly3), "\n\n";

print "poly1 and poly2 overlap? ", polygons_overlap(\@poly1, \@poly2) ? "True" : "False", "\n";
print "poly1 and poly3 overlap? ", polygons_overlap(\@poly1, \@poly3) ? "True" : "False", "\n";
print "poly2 and poly3 overlap? ", polygons_overlap(\@poly2, \@poly3) ? "True" : "False", "\n";
