#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(max);

# Representation of a bipartite graph
# Vertices in the left partition, U, are numbered from 1 to m,
# and vertices in the right partition, V, are numbered 1 to n.
package BipartiteGraph;

sub new {
    my ($class, $m, $n) = @_;
    my $self = {
        m => $m,
        n => $n,
        adjacency_lists => {},
        pair_u => {},
        pair_v => {},
        levels => {},
        NIL => 0,
        INFINITY => 999999999
    };

    # Initialize adjacency lists
    for my $u (1..$m) {
        $self->{adjacency_lists}{$u} = [];
    }

    # Initialize pairs
    for my $u (1..$m) {
        $self->{pair_u}{$u} = $self->{NIL};
    }
    for my $v (1..$n) {
        $self->{pair_v}{$v} = $self->{NIL};
    }

    # Initialize levels
    for my $u (1..$m) {
        $self->{levels}{$u} = $self->{INFINITY};
    }

    bless $self, $class;
    return $self;
}

sub add_edge {
    my ($self, $u, $v) = @_;

    if ($u >= 1 && $u <= $self->{m} && $v >= 1 && $v <= $self->{n}) {
        push @{$self->{adjacency_lists}{$u}}, $v;
    } else {
        die "Attempt to add an edge ($u, $v) which is out of bounds\n";
    }
}

# Return the matching size of the bipartite graph
sub hopcroft_karp_algorithm {
    my ($self) = @_;

    # Reset pairs
    for my $u (1..$self->{m}) {
        $self->{pair_u}{$u} = $self->{NIL};
    }
    for my $v (1..$self->{n}) {
        $self->{pair_v}{$v} = $self->{NIL};
    }

    my $matching_size = 0;

    while ($self->breadth_first_search()) {
        for my $u (1..$self->{m}) {
            if ($self->{pair_u}{$u} == $self->{NIL} && $self->depth_first_search($u)) {
                # vertex u is free and an augmenting path starting
                # from u has been found by the depth first search
                $matching_size++;
            }
        }
    }

    return $matching_size;
}

# Determines whether there exists an augmenting path starting from a free vertex in U.
# Return true if an augmenting path could exist, otherwise false.
sub breadth_first_search {
    my ($self) = @_;

    my @queue = ();

    # Initialize 'levels' for the vertices in U
    for my $u (1..$self->{m}) {
        if ($self->{pair_u}{$u} == $self->{NIL}) {
            # If u is a free vertex, its level is 0 and it is added to the queue
            $self->{levels}{$u} = 0;
            push @queue, $u;
        } else {
            # Otherwise, set 'levels' to infinity
            $self->{levels}{$u} = $self->{INFINITY};
        }
    }

    # The 'level' to the NIL node represents the length of the shortest augmenting path
    $self->{levels}{$self->{NIL}} = $self->{INFINITY};

    while (@queue) {
        my $u = shift @queue;

        if ($self->{levels}{$u} < $self->{levels}{$self->{NIL}}) {
            # The path through u could lead to a shorter augmenting path
            for my $v (@{$self->{adjacency_lists}{$u}}) {
                # Explore the neighbours v of u in V
                my $matched_u = $self->{pair_v}{$v};
                if ($self->{levels}{$matched_u} == $self->{INFINITY}) {
                    # The matched vertex has not been visited yet
                    $self->{levels}{$matched_u} = $self->{levels}{$u} + 1;
                    push @queue, $matched_u; # Enqueue the matched vertex to explore it further
                }
            }
        }
    }

    # An augmenting path from the initial free vertices was found if levels[NIL] is not INFINITY
    return $self->{levels}{$self->{NIL}} != $self->{INFINITY};
}

# Determine whether the shortest path from vertex u in U found by breadth_first_search() can be augmented.
# Return true if an augmenting path was found starting from u, otherwise false.
sub depth_first_search {
    my ($self, $u) = @_;

    if ($u != $self->{NIL}) {
        for my $v (@{$self->{adjacency_lists}{$u}}) {
            # Explore neighbours v of u in V
            my $matched_u = $self->{pair_v}{$v};
            # Check whether the edge (u, v) leads to a vertex matched_u
            # such that the path u -> v -> matched_u is part of a shortest augmenting path
            if ($self->{levels}{$matched_u} == $self->{levels}{$u} + 1) {
                if ($self->depth_first_search($matched_u)) {
                    # An augmenting path is found starting from 'matched_u'
                    $self->{pair_v}{$v} = $u; # Match v with u,
                    $self->{pair_u}{$u} = $v; # and u with v
                    return 1;
                }
            }
        }

        # No augmenting path was found starting from vertex u through any of its neighbours v,
        # so remove u from the depth first search phase of the algorithm
        $self->{levels}{$u} = $self->{INFINITY};
        return 0;
    }

    return 1;
}

package main;

sub test_value {
    my ($test_number, $m, $n, $edges_ref, $expected_result) = @_;

    my $graph = BipartiteGraph->new($m, $n);

    for my $edge (@$edges_ref) {
        $graph->add_edge($edge->{from}, $edge->{to});
    }

    my $result = $graph->hopcroft_karp_algorithm();
    print "Test $test_number: Result = $result, Expected = $expected_result\n";

    if ($result == $expected_result) {
        return 1;
    }

    print "Test $test_number failed.\n";
    return 0;
}

# Main execution
print "Running tests:\n";
my $success_count = 0;

# Test Case 1
$success_count += test_value(1, 3, 5, [{from => 1, to => 4}], 1);

# Test Case 2
$success_count += test_value(2, 6, 6, [
    {from => 1, to => 4},
    {from => 1, to => 5},
    {from => 5, to => 1}
], 2);

# Test Case 3: Complete Bipartite Graph K(3, 3)
my @edges = ();
for my $i (1..3) {
    for my $j (1..3) {
        push @edges, {from => $i, to => $j};
    }
}
$success_count += test_value(3, 3, 3, \@edges, 3);

# Test Case 4: No edges
$success_count += test_value(4, 2, 2, [], 0);

# Test Case 5
@edges = (
    {from => 1, to => 1},
    {from => 1, to => 3},
    {from => 2, to => 3},
    {from => 3, to => 4},
    {from => 4, to => 3},
    {from => 4, to => 2}
);
$success_count += test_value(5, 4, 4, \@edges, 4);

if ($success_count == 5) {
    print "All tests passed.\n";
}
