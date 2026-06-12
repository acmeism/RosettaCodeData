#!/usr/bin/env perl
use strict;
use warnings;
use List::Util qw(first);

# Constants
use constant MAX_SIZE => 2500;
use constant EPSILON => 0.00000001;

# Numerical utilities
sub is_greater_than {
    my ($a, $b) = @_;
    return ($a - $b) > EPSILON;
}

sub is_equal {
    my ($a, $b) = @_;
    return abs($a - $b) < EPSILON;
}

# Vector class
package Vector {
    sub new {
        my ($class, $x, $y, $z, $id) = @_;
        $x //= 0;
        $y //= 0;
        $z //= 0;
        $id //= 0;

        return bless {
            x => $x,
            y => $y,
            z => $z,
            id => $id
        }, $class;
    }

    sub subtract {
        my ($self, $other) = @_;
        return Vector->new(
            $self->{x} - $other->{x},
            $self->{y} - $other->{y},
            $self->{z} - $other->{z}
        );
    }

    sub vector_product {
        my ($self, $other) = @_;
        return Vector->new(
            $self->{y} * $other->{z} - $self->{z} * $other->{y},
            $self->{z} * $other->{x} - $self->{x} * $other->{z},
            $self->{x} * $other->{y} - $self->{y} * $other->{x}
        );
    }

    sub scalar_product {
        my ($self, $other) = @_;
        return $self->{x} * $other->{x} + $self->{y} * $other->{y} + $self->{z} * $other->{z};
    }

    sub magnitude {
        my ($self) = @_;
        return sqrt($self->{x} * $self->{x} + $self->{y} * $self->{y} + $self->{z} * $self->{z});
    }

    sub equals {
        my ($self, $other) = @_;
        return main::is_equal($self->{x}, $other->{x}) &&
               main::is_equal($self->{y}, $other->{y}) &&
               main::is_equal($self->{z}, $other->{z});
    }
}

# Line class
package Line {
    sub new {
        my ($class, $u, $v) = @_;
        return bless {
            u => $u,
            v => $v
        }, $class;
    }
}

# Plane class
package Plane {
    sub new {
        my ($class, $u, $v, $w) = @_;
        return bless {
            u => $u,
            v => $v,
            w => $w
        }, $class;
    }

    sub normal {
        my ($self) = @_;
        return $self->{v}->subtract($self->{u})->vector_product($self->{w}->subtract($self->{u}));
    }

    sub vector_at_index {
        my ($self, $i) = @_;
        return $self->{u} if $i == 0;
        return $self->{v} if $i == 1;
        return $self->{w} if $i == 2;
        return 0;
    }

    sub vector_id {
        my ($self, $i) = @_;
        return $self->vector_at_index($i)->{id};
    }
}

# Facet class
package Facet {
    sub new {
        my ($class, $id, $plane) = @_;
        return bless {
            id => $id // 0,
            plane => $plane,
            N => [],
            visited_time => 0,
            is_deleted => 0
        }, $class;
    }
}

# Edge class
package Edge {
    sub new {
        my ($class) = @_;
        return bless {
            netID => 0,
            faceID => 0
        }, $class;
    }
}

# ConvexHulls3d class
package ConvexHulls3d {
    sub new {
        my ($class, $index) = @_;
        return bless {
            index => $index,
            surface_area => 0.0
        }, $class;
    }

    sub get_surface_area {
        my ($self) = @_;
        if (main::is_greater_than($self->{surface_area}, 0.0)) {
            return $self->{surface_area};
        }

        $main::time_step++;
        $self->dfs_area($self->{index});
        return $self->{surface_area};
    }

    sub dfs_area {
        my ($self, $f) = @_;
        if (($main::facets[$f]->{visited_time} // 0) == $main::time_step) {
            return;
        }

        $main::facets[$f]->{visited_time} = $main::time_step;
        my $normal = $main::facets[$f]->{plane}->normal();
        $self->{surface_area} += $normal->magnitude() / 2.0;

        for my $i (0..2) {
            $self->dfs_area($main::facets[$f]->{N}->[$i]);
        }
    }

    sub get_horizon {
        my ($self, $f, $point, $resDel) = @_;
        my $Ff = $main::facets[$f];

        if (!main::is_above($point, $Ff->{plane})) {
            return 0;
        }

        if (($Ff->{visited_time} // 0) == $main::time_step) {
            return -1;
        }

        $Ff->{visited_time} = $main::time_step;
        $Ff->{is_deleted} = 1;
        push @$resDel, $Ff->{id};

        my $result = -2;
        for my $i (0..2) {
            my $ni = $Ff->{N}->[$i];
            my $horizon = $self->get_horizon($ni, $point, $resDel);

            if ($horizon == 0) {
                my $a = $main::facets[$f]->{plane}->vector_id($i);
                my $b = $main::facets[$f]->{plane}->vector_id(($i + 1) % 3);

                for my $idx (0..1) {
                    my $pt = ($idx == 0) ? $a : $b;
                    my $facet = $ni;

                    if (($main::visit_time[$pt] // 0) != $main::time_step) {
                        $main::visit_time[$pt] = $main::time_step;
                        $main::edges->[0]->[$pt]->{netID} = ($idx == 0) ? $b : $a;
                        $main::edges->[0]->[$pt]->{faceID} = $facet;
                    } else {
                        $main::edges->[1]->[$pt]->{netID} = ($idx == 0) ? $b : $a;
                        $main::edges->[1]->[$pt]->{faceID} = $facet;
                    }
                }
                $result = $a;
            } elsif ($horizon != -1 && $horizon != -2) {
                $result = $horizon;
            }
        }
        return $result;
    }
}

# Global variables
our @facets;
our @hull_points;
our $time_step = 0;
our $edges;
our @visit_time;
our @queue;
our @resfnew;
our @resfdel;
our @respt;

# Geometric utilities
sub distance_point_plane {
    my ($vec, $plane) = @_;
    my $num = $vec->subtract($plane->{u})->scalar_product($plane->normal());
    my $den = $plane->normal()->magnitude();
    return $num / $den;
}

sub distance_point_line {
    my ($vec, $line) = @_;
    my $length = $vec->subtract($line->{u})->magnitude();
    return 0.0 if $length == 0.0;

    return $line->{v}->subtract($line->{u})->vector_product($vec->subtract($line->{u}))->magnitude() /
           $line->{v}->subtract($line->{u})->magnitude();
}

sub distance_point_point {
    my ($a, $b) = @_;
    return $a->subtract($b)->magnitude();
}

sub is_above {
    my ($point, $plane) = @_;
    return is_greater_than($point->subtract($plane->{u})->scalar_product($plane->normal()), 0.0);
}

sub prepare_convex_hulls {
    # Reserve index 0
    push @hull_points, [];
    push @facets, Facet->new();

    # Initialize edge vector
    $edges = [];
    for my $i (0..1) {
        $edges->[$i] = [];
        for my $j (0..MAX_SIZE-1) {
            $edges->[$i]->[$j] = Edge->new();
        }
    }

    # Initialize visit_time array
    @visit_time = (0) x MAX_SIZE;
}

sub get_initial_hull {
    my ($points, $total_points) = @_;

    my @extremes = ($points->[1]) x 6;

    for my $i (1..$total_points) {
        my $point = $points->[$i];
        $extremes[0] = $point if is_greater_than($point->{x}, $extremes[0]->{x});
        $extremes[1] = $point if is_greater_than($extremes[1]->{x}, $point->{x});
        $extremes[2] = $point if is_greater_than($point->{y}, $extremes[2]->{y});
        $extremes[3] = $point if is_greater_than($extremes[3]->{y}, $point->{y});
        $extremes[4] = $point if is_greater_than($point->{z}, $extremes[4]->{z});
        $extremes[5] = $point if is_greater_than($extremes[5]->{z}, $point->{z});
    }

    # Furthest pair
    my $extreme0 = $extremes[0];
    my $extreme1 = $extremes[1];
    for my $i (0..5) {
        for my $j ($i+1..5) {
            my $distance = distance_point_point($extremes[$i], $extremes[$j]);
            if (is_greater_than($distance, distance_point_point($extreme0, $extreme1))) {
                $extreme0 = $extremes[$i];
                $extreme1 = $extremes[$j];
            }
        }
    }

    # Furthest from line
    my $line = Line->new($extreme0, $extreme1);
    my $extreme2 = $extremes[0];
    for my $i (0..5) {
        if (is_greater_than(distance_point_line($extremes[$i], $line), distance_point_line($extreme2, $line))) {
            $extreme2 = $extremes[$i];
        }
    }

    # Furthest from plane
    my $extreme3 = $points->[1];
    my $basePlane = Plane->new($extreme0, $extreme1, $extreme2);
    for my $i (1..$total_points) {
        my $distance1 = abs(distance_point_plane($points->[$i], $basePlane));
        my $distance2 = abs(distance_point_plane($extreme3, $basePlane));
        if (is_greater_than($distance1, $distance2)) {
            $extreme3 = $points->[$i];
        }
    }

    if (is_greater_than(0, distance_point_plane($extreme3, $basePlane))) {
        ($extreme1, $extreme2) = ($extreme2, $extreme1);
    }

    # Create 4 initial facets
    my @f;
    for my $i (0..3) {
        push @facets, Facet->new(scalar @facets);
        $f[$i] = $#facets;
    }

    $facets[$f[0]]->{plane} = Plane->new($extreme0, $extreme2, $extreme1);
    $facets[$f[1]]->{plane} = Plane->new($extreme0, $extreme1, $extreme3);
    $facets[$f[2]]->{plane} = Plane->new($extreme1, $extreme2, $extreme3);
    $facets[$f[3]]->{plane} = Plane->new($extreme2, $extreme0, $extreme3);

    $facets[$f[0]]->{N} = [$f[3], $f[2], $f[1]];
    $facets[$f[1]]->{N} = [$f[0], $f[2], $f[3]];
    $facets[$f[2]]->{N} = [$f[0], $f[3], $f[1]];
    $facets[$f[3]]->{N} = [$f[0], $f[1], $f[2]];

    # Prepare hull_points array
    for my $i (0..3) {
        push @hull_points, [];
    }

    # Assign points
    for my $i (1..$total_points) {
        my $point = $points->[$i];
        next if ($point->equals($extreme0) || $point->equals($extreme1) ||
                $point->equals($extreme2) || $point->equals($extreme3));

        for my $j (0..3) {
            if (is_above($point, $facets[$f[$j]]->{plane})) {
                push @{$hull_points[$f[$j]]}, $point;
                last;
            }
        }
    }

    return ConvexHulls3d->new($f[0]);
}

sub QuickHull3D {
    my ($points, $total_points) = @_;
    my $hull = get_initial_hull($points, $total_points);

    # Initialize queue
    @queue = ();
    push @queue, $hull->{index};
    for my $i (0..2) {
        push @queue, $facets[$hull->{index}]->{N}->[$i];
    }

    my $new_horizon = 0;

    while (@queue) {
        my $nf = shift @queue;

        if ($facets[$nf]->{is_deleted} || !@{$hull_points[$nf]}) {
            if (!$facets[$nf]->{is_deleted}) {
                $new_horizon = $nf;
            }
            next;
        }

        # Farthest point
        my $point = $hull_points[$nf]->[0];
        for my $vec (@{$hull_points[$nf]}) {
            if (is_greater_than(distance_point_plane($vec, $facets[$nf]->{plane}),
                              distance_point_plane($point, $facets[$nf]->{plane}))) {
                $point = $vec;
            }
        }

        # Find horizon
        $time_step++;
        @resfdel = ();
        my $horizon = $hull->get_horizon($nf, $point, \@resfdel);

        # Build new faces
        @resfnew = ();
        $time_step++;
        my $from = -1;
        my $last_f = -1;
        my $first_f = -1;

        while (($visit_time[$horizon] // 0) != $time_step) {
            $visit_time[$horizon] = $time_step;
            my ($net, $f, $new_f);

            if ($edges->[0]->[$horizon]->{netID} == $from) {
                $net = $edges->[1]->[$horizon]->{netID};
                $f = $edges->[1]->[$horizon]->{faceID};
            } else {
                $net = $edges->[0]->[$horizon]->{netID};
                $f = $edges->[0]->[$horizon]->{faceID};
            }

            # Find indices on facet f
            my ($pt1, $pt2) = (0, 0);
            for my $i (0..2) {
                $pt1 = $i if $points->[$horizon]->equals($facets[$f]->{plane}->vector_at_index($i));
                $pt2 = $i if $points->[$net]->equals($facets[$f]->{plane}->vector_at_index($i));
            }
            if (($pt1 + 1) % 3 != $pt2) {
                ($pt1, $pt2) = ($pt2, $pt1);
            }

            # Create new facet
            push @facets, Facet->new(
                scalar @facets,
                Plane->new(
                    $facets[$f]->{plane}->vector_at_index($pt2),
                    $facets[$f]->{plane}->vector_at_index($pt1),
                    $point
                )
            );
            $new_f = $#facets;
            push @hull_points, [];
            push @resfnew, $new_f;

            $facets[$new_f]->{N}->[0] = $f;
            $facets[$f]->{N}->[$pt1] = $new_f;

            if ($last_f >= 0) {
                # Link with previous new facet
                if ($facets[$new_f]->{plane}->vector_at_index(1)->equals($facets[$last_f]->{plane}->{u})) {
                    $facets[$new_f]->{N}->[1] = $last_f;
                    $facets[$last_f]->{N}->[2] = $new_f;
                } else {
                    $facets[$new_f]->{N}->[2] = $last_f;
                    $facets[$last_f]->{N}->[1] = $new_f;
                }
            } else {
                $first_f = $new_f;
            }

            $last_f = $new_f;
            $from = $horizon;
            $horizon = $net;
        }

        # Close the loop
        if ($facets[$first_f]->{plane}->vector_at_index(1)->equals($facets[$last_f]->{plane}->{u})) {
            $facets[$first_f]->{N}->[1] = $last_f;
            $facets[$last_f]->{N}->[2] = $first_f;
        } else {
            $facets[$first_f]->{N}->[2] = $last_f;
            $facets[$last_f]->{N}->[1] = $first_f;
        }

        # Collect deleted points
        @respt = ();
        for my $f_id (@resfdel) {
            push @respt, @{$hull_points[$f_id]};
            $hull_points[$f_id] = [];
        }

        # Reassign
        for my $vec (@respt) {
            next if $vec->equals($point);
            for my $f_id (@resfnew) {
                if (is_above($vec, $facets[$f_id]->{plane})) {
                    push @{$hull_points[$f_id]}, $vec;
                    last;
                }
            }
        }

        # Enqueue new faces
        push @queue, @resfnew;
    }

    $hull->{index} = $new_horizon;
    return $hull;
}

# Main program
prepare_convex_hulls();

# Example: a tetrahedron
my $n = 4;
my @points = (undef); # Index 0 is unused
push @points, Vector->new(0, 0, 0, 1);
push @points, Vector->new(1, 0, 0, 2);
push @points, Vector->new(0, 1, 0, 3);
push @points, Vector->new(0, 0, 1, 4);

my $hull = QuickHull3D(\@points, $n);
printf "%.3f\n", $hull->get_surface_area();
