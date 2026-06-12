#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(shuffle min);
use Data::Dumper;

# --- Helper Structs/Classes ---

package Point;
sub new {
    my ($class, $x, $y, $id) = @_;
    return bless {
        x => $x,
        y => $y,
        id => $id
    }, $class;
}

package Edge;
sub new {
    my ($class, $u, $v, $weight) = @_;
    return bless {
        u => $u,
        v => $v,
        weight => $weight
    }, $class;
}

package UnionFind;
sub new {
    my ($class, $n) = @_;
    my $self = {
        parent => [0..$n-1],
        rank => [(0) x $n]
    };
    return bless $self, $class;
}

sub find {
    my ($self, $i) = @_;
    if ($self->{parent}[$i] != $i) {
        # Path compression
        $self->{parent}[$i] = $self->find($self->{parent}[$i]);
    }
    return $self->{parent}[$i];
}

sub unite {
    my ($self, $i, $j) = @_;
    my $root_i = $self->find($i);
    my $root_j = $self->find($j);

    if ($root_i != $root_j) {
        # Union by rank
        if ($self->{rank}[$root_i] < $self->{rank}[$root_j]) {
            $self->{parent}[$root_i] = $root_j;
        } elsif ($self->{rank}[$root_i] > $self->{rank}[$root_j]) {
            $self->{parent}[$root_j] = $root_i;
        } else {
            $self->{parent}[$root_j] = $root_i;
            $self->{rank}[$root_i]++;
        }
    }
}

package main;

# --- Helper Functions ---

sub print_container {
    my ($container, $name) = @_;
    print "$name: [" . join(", ", @$container) . "]\n";
}

sub print_edges {
    my ($edges, $name) = @_;
    print "$name: [";
    my @edge_strings;
    for my $edge (@$edges) {
        push @edge_strings, sprintf("(%d, %d, %.2f)", $edge->{u}, $edge->{v}, $edge->{weight});
    }
    print join(", ", @edge_strings) . "]\n";
}

sub print_graph {
    my ($graph, $name) = @_;
    print "$name: {\n";
    my $n = @$graph;
    for my $i (0..$n-1) {
        print "  $i: {";
        my @pairs;
        for my $j (0..$n-1) {
            if ($i != $j) {
                push @pairs, sprintf("%d: %.2f", $j, $graph->[$i][$j]);
            }
        }
        print join(", ", @pairs);
        print "}" . ($i == $n-1 ? "" : ",") . "\n";
    }
    print "}\n";
}

# --- Euclidean Distance ---
sub get_length {
    my ($p1, $p2) = @_;
    my $dx = $p1->{x} - $p2->{x};
    my $dy = $p1->{y} - $p2->{y};
    return sqrt($dx * $dx + $dy * $dy);
}

# --- Build Complete Graph (Adjacency Matrix) ---
sub build_graph {
    my ($data) = @_;
    my $n = @$data;
    my @graph;

    for my $i (0..$n-1) {
        for my $j (0..$n-1) {
            $graph[$i][$j] = 0.0;
        }
    }

    for my $i (0..$n-1) {
        for my $j ($i+1..$n-1) {
            my $dist = get_length($data->[$i], $data->[$j]);
            $graph[$i][$j] = $dist;
            $graph[$j][$i] = $dist; # Symmetric graph
        }
    }

    return \@graph;
}

# --- Minimum Spanning Tree (Kruskal's Algorithm) ---
sub minimum_spanning_tree {
    my ($graph) = @_;
    my $n = @$graph;
    return [] if $n == 0;

    my @edges;
    for my $i (0..$n-1) {
        for my $j ($i+1..$n-1) {
            push @edges, Edge->new($i, $j, $graph->[$i][$j]);
        }
    }

    # Sort edges by weight
    @edges = sort { $a->{weight} <=> $b->{weight} } @edges;

    my @mst;
    my $uf = UnionFind->new($n);
    my $edges_count = 0;

    for my $edge (@edges) {
        if ($uf->find($edge->{u}) != $uf->find($edge->{v})) {
            push @mst, $edge;
            $uf->unite($edge->{u}, $edge->{v});
            $edges_count++;
            last if $edges_count == $n - 1; # MST has n-1 edges
        }
    }

    return \@mst;
}

# --- Find Vertices with Odd Degree in MST ---
sub find_odd_vertexes {
    my ($mst, $n) = @_;
    my @degree = (0) x $n;

    for my $edge (@$mst) {
        $degree[$edge->{u}]++;
        $degree[$edge->{v}]++;
    }

    my @odd_vertices;
    for my $i (0..$n-1) {
        if ($degree[$i] % 2 != 0) {
            push @odd_vertices, $i;
        }
    }

    return \@odd_vertices;
}

# --- Minimum Weight Matching (Greedy Heuristic) ---
sub minimum_weight_matching {
    my ($mst, $graph, $odd_vertices) = @_;

    # Use a copy to allow modification while iterating
    my @current_odd = shuffle(@$odd_vertices);

    # Keep track of vertices already matched in this phase
    my @matched = (0) x @$graph;

    for my $i (0..$#current_odd) {
        my $v = $current_odd[$i];
        next if $matched[$v]; # Skip if already matched

        my $min_length = 'inf';
        my $closest_u = -1;

        # Find the closest unmatched odd vertex
        for my $j ($i+1..$#current_odd) {
            my $u = $current_odd[$j];
            if (!$matched[$u]) { # Check if 'u' is available
                if ($graph->[$v][$u] < $min_length) {
                    $min_length = $graph->[$v][$u];
                    $closest_u = $u;
                }
            }
        }

        if ($closest_u != -1) {
            # Add the matching edge to the MST list (now a multigraph)
            push @$mst, Edge->new($v, $closest_u, $min_length);
            $matched[$v] = 1;
            $matched[$closest_u] = 1; # Mark both as matched
        }
    }
}

# --- Find Eulerian Tour (Hierholzer's Algorithm) ---
sub find_eulerian_tour {
    my ($matched_mst, $n) = @_;
    return [] if @$matched_mst == 0;

    # Build adjacency list representation of the multigraph
    my @adj;
    for my $i (0..$n-1) {
        $adj[$i] = [];
    }

    my %edge_used;
    for my $edge (@$matched_mst) {
        push @{$adj[$edge->{u}]}, [$edge->{v}, $edge];
        push @{$adj[$edge->{v}]}, [$edge->{u}, $edge];
        $edge_used{$edge} = 0;
    }

    my @tour;
    my @current_path;

    # Start at any vertex with edges
    my $start_node = $matched_mst->[0]->{u};
    push @current_path, $start_node;

    while (@current_path) {
        my $current_node = $current_path[-1];
        my $found_edge = 0;

        # Find an unused edge from the current node
        for my $neighbor_info (@{$adj[$current_node]}) {
            my ($neighbor, $edge_ptr) = @$neighbor_info;

            if (!$edge_used{$edge_ptr}) {
                $edge_used{$edge_ptr} = 1; # Mark edge as used

                # Push neighbor onto stack and move to it
                push @current_path, $neighbor;
                $found_edge = 1;
                last; # Move to the neighbor
            }
        }

        # If no unused edge was found from current_node, backtrack
        if (!$found_edge) {
            push @tour, pop @current_path;
        }
    }

    # The tour is constructed in reverse order
    return [reverse @tour];
}

# --- Main TSP Function (Christofides Approximation) ---
sub tsp {
    my ($data) = @_;
    my $n = @$data;

    return (0.0, []) if $n == 0;
    return (0.0, [$data->[0]->{id}]) if $n == 1;

    # Build a graph
    my $G = build_graph($data);
    # print_graph($G, "Graph");

    # Build a minimum spanning tree
    my $MSTree = minimum_spanning_tree($G);
    print_edges($MSTree, "MSTree");

    # Find odd degree vertices
    my $odd_vertexes = find_odd_vertexes($MSTree, $n);
    print_container($odd_vertexes, "Odd vertexes in MSTree");

    # Add minimum weight matching edges
    minimum_weight_matching($MSTree, $G, $odd_vertexes);
    print_edges($MSTree, "Minimum weight matching (MST + Matching Edges)");

    # Find an Eulerian tour in the combined graph
    my $eulerian_tour = find_eulerian_tour($MSTree, $n);
    print_container($eulerian_tour, "Eulerian tour");

    # --- Create Hamiltonian Circuit by Skipping Visited Nodes ---
    if (@$eulerian_tour == 0) {
        warn "Error: Eulerian tour could not be found.\n";
        return (-1.0, []); # Indicate error
    }

    my @path;
    my $length = 0.0;
    my @visited = (0) x $n;

    my $current = $eulerian_tour->[0];
    push @path, $current;
    $visited[$current] = 1;

    for my $i (1..$#$eulerian_tour) {
        my $v = $eulerian_tour->[$i];
        if (!$visited[$v]) {
            push @path, $v;
            $visited[$v] = 1;
            $length += $G->[$current][$v]; # Add distance from previous node in path
            $current = $v; # Update current node in path
        }
    }

    # Add the edge back to the start
    $length += $G->[$current][$path[0]];
    push @path, $path[0]; # Complete the cycle

    print_container(\@path, "Result path");
    printf "Result length of the path: %.2f\n", $length;

    return ($length, \@path);
}

# --- Main Program ---

# Input data matching the C++ example
my @raw_data = (
    [1380, 939], [2848, 96], [3510, 1671], [457, 334], [3888, 666], [984, 965], [2721, 1482], [1286, 525],
    [2716, 1432], [738, 1325], [1251, 1832], [2728, 1698], [3815, 169], [3683, 1533], [1247, 1945], [123, 862],
    [1234, 1946], [252, 1240], [611, 673], [2576, 1676], [928, 1700], [53, 857], [1807, 1711], [274, 1420],
    [2574, 946], [178, 24], [2678, 1825], [1795, 962], [3384, 1498], [3520, 1079], [1256, 61], [1424, 1728],
    [3913, 192], [3085, 1528], [2573, 1969], [463, 1670], [3875, 598], [298, 1513], [3479, 821], [2542, 236],
    [3955, 1743], [1323, 280], [3447, 1830], [2936, 337], [1621, 1830], [3373, 1646], [1393, 1368],
    [3874, 1318], [938, 955], [3022, 474], [2482, 1183], [3854, 923], [376, 825], [2519, 135], [2945, 1622],
    [953, 268], [2628, 1479], [2097, 981], [890, 1846], [2139, 1806], [2421, 1007], [2290, 1810], [1115, 1052],
    [2588, 302], [327, 265], [241, 341], [1917, 687], [2991, 792], [2573, 599], [19, 674], [3911, 1673],
    [872, 1559], [2863, 558], [929, 1766], [839, 620], [3893, 102], [2178, 1619], [3822, 899], [378, 1048],
    [1178, 100], [2599, 901], [3416, 143], [2961, 1605], [611, 1384], [3113, 885], [2597, 1830], [2586, 1286],
    [161, 906], [1429, 134], [742, 1025], [1625, 1651], [1187, 706], [1787, 1009], [22, 987], [3640, 43],
    [3756, 882], [776, 392], [1724, 1642], [198, 1810], [3950, 1558]
);

my @data_points;
for my $i (0..$#raw_data) {
    push @data_points, Point->new($raw_data[$i][0], $raw_data[$i][1], $i);
}

tsp(\@data_points);
