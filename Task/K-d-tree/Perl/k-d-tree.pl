# 20240917 Perl programming solution

use strict;
use warnings;
use List::Util qw(sum);
use Time::HiRes qw(time);

package KdNode {
   sub new {
      my ($class, $dom_elt, $split, $left, $right) = @_;
      return bless { dom_elt => $dom_elt, split => $split,
                     left    => $left,    right => $right }, $class;
   }
}

package Orthotope {
   sub new {
      my ($class, $min, $max) = @_;
      return bless { min => $min, max => $max }, $class
   }
}

package KdTree {
   use POSIX qw(floor);
   sub new {
      my ($class, $pts, $bounds) = @_;
      my $self = bless {}, $class;
      $self->{n} = $self->nk2(0, $pts);
      $self->{bounds} = $bounds;
      return $self
   }

   sub nk2 {
      my ($self, $split, $exset) = @_;
      return undef unless @$exset;

      my @exset = sort { $a->[$split] <=> $b->[$split] } @$exset;
      my $d = $exset[ my $m = floor(@exset / 2) ];

      while ($m + 1 < @exset && $exset[$m + 1]->[$split] == $d->[$split]) {
         $m++
      }

      my $s2 = ($split + 1) % scalar @$d;

      return KdNode->new(
         $d,
         $split,
         $self->nk2($s2, [ @exset[0 .. $m - 1] ]),
         $self->nk2($s2, [ @exset[$m + 1 .. $#exset] ])
      )
   }
}

package T3 {
   sub new {
      my ($class, $nearest, $dist_sqd, $nodes_visited) = @_;
      return bless { nearest       => $nearest, dist_sqd => $dist_sqd,
                     nodes_visited => $nodes_visited }, $class
   }
}

sub find_nearest {
   my ($k, $tree, $p) = @_;
   my $nn;

   $nn = sub {
       my ($kd, $target, $hr, $max_dist_sqd) = @_;
       return T3->new([0.0] x $k, 'inf', 0) unless $kd;

       my ($nodes_visited, $s, $pivot) = (1, $kd->{split}, $kd->{dom_elt});

       my $left_hr = Orthotope->new([ @{$hr->{min}} ], [ @{$hr->{max}} ]);
       my $right_hr = Orthotope->new([ @{$hr->{min}} ], [ @{$hr->{max}} ]);
       $left_hr->{max}->[$s] = $pivot->[$s];
       $right_hr->{min}->[$s] = $pivot->[$s];

       my ($nearer_kd, $further_kd, $nearer_hr, $further_hr);
       if ($target->[$s] <= $pivot->[$s]) {
          ($nearer_kd, $nearer_hr) = ($kd->{left}, $left_hr);
          ($further_kd, $further_hr) = ($kd->{right}, $right_hr);
       } else {
          ($nearer_kd, $nearer_hr) = ($kd->{right}, $right_hr);
          ($further_kd, $further_hr) = ($kd->{left}, $left_hr);
       }

       my $n1 = $nn->($nearer_kd, $target, $nearer_hr, $max_dist_sqd);
       my $nearest = $n1->{nearest};
       my $dist_sqd = $n1->{dist_sqd};
       $nodes_visited += $n1->{nodes_visited};

       if ($dist_sqd < $max_dist_sqd) { $max_dist_sqd = $dist_sqd }

       my $d = ($pivot->[$s] - $target->[$s]) ** 2;
       return T3->new($nearest, $dist_sqd, $nodes_visited)
          if $d > $max_dist_sqd;

       $d = sum(map { ($pivot->[$_] - $target->[$_]) ** 2 } 0 .. $#$pivot);
       if ($d < $dist_sqd) {
          $nearest = $pivot;
          $dist_sqd = $d;
          $max_dist_sqd = $dist_sqd;
       }

       my $n2 = $nn->($further_kd, $target, $further_hr, $max_dist_sqd);
       $nodes_visited += $n2->{nodes_visited};
       if ($n2->{dist_sqd} < $dist_sqd) {
          $nearest = $n2->{nearest};
          $dist_sqd = $n2->{dist_sqd};
       }
       return T3->new($nearest, $dist_sqd, $nodes_visited);
    };
    return $nn->($tree->{n}, $p, $tree->{bounds}, 'inf');
}

sub random_point {
   my ($k) = @_;
   return [ map { rand() } 1 .. $k ];
}

sub random_points {
   my ($k, $n) = @_;
   return [ map { random_point($k) } 1 .. $n ];
}

sub show_nearest {
   my ($k, $heading, $kd, $p) = @_;
   print "$heading:\n";
   print "Point:            [", join(", ", @$p), "]\n";
   my $n = find_nearest($k, $kd, $p);
   print "Nearest neighbor: [", join(", ", @{$n->{nearest}}), "]\n";
   print "Distance:         ", sqrt($n->{dist_sqd}), "\n";
   print "Nodes visited:    $n->{nodes_visited}\n\n";
}

srand(1);
my $kd1 = KdTree->new([[2, 3], [5, 4], [9, 6], [4, 7], [8, 1], [7, 2]], Orthotope->new([0, 0], [10, 10]));
show_nearest(2, "Wikipedia example data", $kd1, [9, 2]);

my $N = 40000;
my $t0 = time;
my $kd2 = KdTree->new(random_points(3, $N), Orthotope->new([0, 0, 0], [1, 1, 1]));
my $t1 = time;
show_nearest(3, "k-d tree with $N random 3D points (generation time: " . ($t1 - $t0) . "s)", $kd2, random_point(3));
