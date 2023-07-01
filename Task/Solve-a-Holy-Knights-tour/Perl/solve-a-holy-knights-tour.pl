package KT_Locations;
# A sequence of locations on a 2-D board whose order might or might not
# matter. Suitable for representing a partial tour, a complete tour, or the
# required locations to visit.
use strict;
use overload '""' => "as_string";
use English;
# 'locations' must be a reference to an array of 2-element array references,
# where the first element is the rank index and the second is the file index.
use Class::Tiny qw(N locations);
use List::Util qw(all);

sub BUILD {
    my $self = shift;
    $self->{N} //= 8;
    $self->{N} >= 3 or die "N must be at least 3";
    all {ref($ARG) eq 'ARRAY' && scalar(@{$ARG}) == 2} @{$self->{locations}}
        or die "At least one element of 'locations' is invalid";
    return;
}

sub as_string {
    my $self = shift;
    my %idxs;
    my $idx = 1;
    foreach my $loc (@{$self->locations}) {
        $idxs{join(q{K},@{$loc})} = $idx++;
    }
    my $str;
    {
        my $w = int(log(scalar(@{$self->locations}))/log(10.)) + 2;
        my $fmt = "%${w}d";
        my $N = $self->N;
        my $non_tour = q{ } x ($w-1) . q{-};
        for (my $r=0; $r<$N; $r++) {
            for (my $f=0; $f<$N; $f++) {
                my $k = join(q{K}, $r, $f);
                $str .= exists($idxs{$k}) ? sprintf($fmt, $idxs{$k}) : $non_tour;
            }
            $str .= "\n";
        }
    }
    return $str;
}

sub as_idx_hash {
    my $self = shift;
    my $N = $self->N;
    my $result;
    foreach my $pair (@{$self->locations}) {
        my ($r, $f) = @{$pair};
        $result->{$r * $N + $f}++;
    }
    return $result;
}

package KnightsTour;
use strict;
# If supplied, 'str' is parsed to set 'N', 'start_location', and
# 'locations_to_visit'.  'legal_move_idxs' is for improving performance.
use Class::Tiny qw( N start_location locations_to_visit str legal_move_idxs );
use English;
use Parallel::ForkManager;
use Time::HiRes qw( gettimeofday tv_interval );

sub BUILD {
    my $self = shift;
    if ($self->{str}) {
        my ($n, $sl, $ltv) = _parse_input_string($self->{str});
        $self->{N} = $n;
        $self->{start_location} = $sl;
        $self->{locations_to_visit} = $ltv;
    }
    $self->{N} //= 8;
    $self->{N} >= 3 or die "N must be at least 3";
    exists($self->{start_location}) or die "Must supply start_location";
    die "start_location is invalid"
        if ref($self->{start_location}) ne 'ARRAY' ||
           scalar(@{$self->{start_location}}) != 2;
    exists($self->{locations_to_visit}) or die "Must supply locations_to_visit";
    ref($self->{locations_to_visit}) eq 'KT_Locations'
        or die "locations_to_visit must be a KT_Locations instance";
    $self->{N} == $self->{locations_to_visit}->N
        or die "locations_to_visit has mismatched board size";
    $self->precompute_legal_moves();
    return;
}

sub _parse_input_string {
    my @rows = split(/[\r\n]+/s, shift);
    my $N = scalar(@rows);
    my ($start_location, @to_visit);
    for (my $r=0; $r<$N; $r++) {
        my $row_r = $rows[$r];
        for (my $f=0; $f<$N; $f++) {
            my $c = substr($row_r, $f, 1);
            if ($c eq '1') { $start_location = [$r, $f]; }
            elsif ($c eq '0') { push @to_visit, [$r, $f]; }
        }
    }
    $start_location or die "No starting location provided";
    return ($N,
            $start_location,
            KT_Locations->new(N => $N, locations => \@to_visit));
}

sub precompute_legal_moves {
    my $self = shift;
    my $N = $self->{N};
    my $ktl_ixs = $self->{locations_to_visit}->as_idx_hash();
    for (my $r=0; $r<$N; $r++) {
        for (my $f=0; $f<$N; $f++) {
            my $k = $r * $N + $f;
            $self->{legal_move_idxs}->{$k} =
                _precompute_legal_move_idxs($r, $f, $N, $ktl_ixs);
        }
    }
    return;
}

sub _precompute_legal_move_idxs {
    my ($r, $f, $N, $ktl_ixs) = @ARG;
    my $r_plus_1  = $r + 1;  my $r_plus_2 = $r + 2;
    my $r_minus_1 = $r - 1;  my $r_minus_2 = $r - 2;
    my $f_plus_1  = $f + 1;  my $f_plus_2 = $f + 2;
    my $f_minus_1 = $f - 1;  my $f_minus_2 = $f - 2;
    my @result = grep { exists($ktl_ixs->{$ARG}) }
                 map { $ARG->[0] * $N + $ARG->[1] }
                 grep {$ARG->[0] >= 0 && $ARG->[0] < $N &&
                       $ARG->[1] >= 0 && $ARG->[1] < $N}
                      ([$r_plus_2,  $f_minus_1], [$r_plus_2,  $f_plus_1],
                       [$r_minus_2, $f_minus_1], [$r_minus_2, $f_plus_1],
                       [$r_plus_1,  $f_plus_2],  [$r_plus_1,  $f_minus_2],
                       [$r_minus_1, $f_plus_2],  [$r_minus_1, $f_minus_2]);
    return \@result;
}

sub find_tour {
    my $self = shift;
    my $num_to_visit = scalar(@{$self->locations_to_visit->locations});
    my $N = $self->N;
    my $start_loc_idx =
        $self->start_location->[0] * $N + $self->start_location->[1];
    my $visited;  for (my $i=0; $i<$N*$N; $i++) { vec($visited, $i, 1) = 0; }
    vec($visited, $start_loc_idx, 1) = 1;
    # We unwind the search by one level and use Parallel::ForkManager to search
    # the top-level sub-trees concurrently, assuming there are enough cores.
    my @next_loc_idxs = @{$self->legal_move_idxs->{$start_loc_idx}};
    my $pm = new Parallel::ForkManager(scalar(@next_loc_idxs));
    foreach my $next_loc_idx (@next_loc_idxs) {
        $pm->start and next;  # Do the fork
        my $t0 = [gettimeofday];
        vec($visited, $next_loc_idx, 1) = 1;  # (The fork cloned $visited.)
        my $tour = _find_tour_helper($N,
                                     $num_to_visit - 1,
                                     $next_loc_idx,
                                     $visited,
                                     $self->legal_move_idxs);
        my $elapsed = tv_interval($t0);
        my ($r, $f) = _idx_to_rank_and_file($next_loc_idx, $N);
        if (defined $tour) {
            my @tour_locs =
                map { [_idx_to_rank_and_file($ARG, $N)] }
                    ($start_loc_idx, $next_loc_idx, split(/\s+/s, $tour));
            my $kt_locs = KT_Locations->new(N => $N, locations => \@tour_locs);
            print "Found a tour after first move ($r, $f) ",
                  "in $elapsed seconds:\n", $kt_locs, "\n";
        }
        else {
            print "No tour found after first move ($r, $f). ",
                  "Took $elapsed seconds.\n";
        }
        $pm->finish; # Do the exit in the child process
    }
    $pm->wait_all_children;
    return;
}

sub _idx_to_rank_and_file {
    my ($idx, $N) = @ARG;
    my $f = $idx % $N;
    my $r = ($idx - $f) / $N;
    return ($r, $f);
}

sub _find_tour_helper {
    my ($N, $num_to_visit, $current_loc_idx, $visited, $legal_move_idxs) = @ARG;

    # The performance hot spot.
    local *inner_helper = sub {
        my ($num_to_visit, $current_loc_idx, $visited) = @ARG;
        if ($num_to_visit == 0) {
            return q{ };  # Solution found.
        }
        my @next_loc_idxs = @{$legal_move_idxs->{$current_loc_idx}};
        my $num_to_visit2 = $num_to_visit - 1;
        foreach my $loc_idx2 (@next_loc_idxs) {
            next if vec($visited, $loc_idx2, 1);
            my $visited2 = $visited;
            vec($visited2, $loc_idx2, 1) = 1;
            my $recursion = inner_helper($num_to_visit2, $loc_idx2, $visited2);
            return $loc_idx2 . q{ } . $recursion if defined $recursion;
        }
        return;
    };

    return inner_helper($num_to_visit, $current_loc_idx, $visited);
}

package main;
use strict;

solve_size_8_problem();
solve_size_13_problem();
exit 0;

sub solve_size_8_problem {
    my $problem = <<"END_SIZE_8_PROBLEM";
--000---
--0-00--
-0000000
000--0-0
0-0--000
1000000-
--00-0--
---000--
END_SIZE_8_PROBLEM
    my $kt = KnightsTour->new(str => $problem);
    print "Finding a tour for an 8x8 problem...\n";
    $kt->find_tour();
    return;
}

sub solve_size_13_problem {
    my $problem = <<"END_SIZE_13_PROBLEM";
-----1-0-----
-----0-0-----
----00000----
-----000-----
--0--0-0--0--
00000---00000
--00-----00--
00000---00000
--0--0-0--0--
-----000-----
----00000----
-----0-0-----
-----0-0-----
END_SIZE_13_PROBLEM
    my $kt = KnightsTour->new(str => $problem);
    print "Finding a tour for a 13x13 problem...\n";
    $kt->find_tour();
    return;
}
