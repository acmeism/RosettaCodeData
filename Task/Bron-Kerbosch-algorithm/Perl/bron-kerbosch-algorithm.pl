use strict;
use warnings;
use Data::Dumper;

my @edges = (
    { start => "a", end => "b" },
    { start => "b", end => "a" },
    { start => "a", end => "c" },
    { start => "c", end => "a" },
    { start => "b", end => "c" },
    { start => "c", end => "b" },
    { start => "d", end => "e" },
    { start => "e", end => "d" },
    { start => "d", end => "f" },
    { start => "f", end => "d" },
    { start => "e", end => "f" },
    { start => "f", end => "e" },
);

# Build the graph as an adjacency list
my %graph;
foreach my $edge (@edges) {
    push @{ $graph{ $edge->{start} } }, $edge->{end};
}

# Initialize current clique, candidates, and processed vertices
my @current_clique;
my %candidates = map { $_ => 1 } keys %graph;
my %processed_vertices;

# Execute the Bron-Kerbosch algorithm to collect the cliques
my @cliques;
bron_kerbosch(\@current_clique, \%candidates, \%processed_vertices, \%graph, \@cliques);

# Sort the cliques for consistent display
@cliques = sort { list_comparator($a, $b) } @cliques;

# Display the cliques
print Dumper(\@cliques);

sub bron_kerbosch {
    my ($current_clique, $candidates, $processed_vertices, $graph, $cliques) = @_;

    if (!%$candidates && !%$processed_vertices) {
        if (@$current_clique > 2) {
            push @$cliques, [@$current_clique];
        }
        return;
    }

    # Select a pivot vertex from 'candidates' union 'processedVertices' with the maximum degree
    my %union = (%$candidates, %$processed_vertices);
    my $pivot = max_degree_vertex(\%union, $graph);

    # 'possibles' are vertices in 'candidates' that are not neighbors of the 'pivot'
    my %possibles = %$candidates;
    delete $possibles{$_} for @{ $graph->{$pivot} };

    foreach my $vertex (keys %possibles) {
        # Create a new clique including 'vertex'
        my @new_cliques = @$current_clique;
        push @new_cliques, $vertex;

        # 'newCandidates' are the members of 'candidates' that are neighbors of 'vertex'
        my %neighbors = map { $_ => 1 } @{ $graph->{$vertex} };
        my %new_candidates = map { $_ => 1 } grep { $neighbors{$_} } keys %$candidates;

        # 'newProcessedVertices' are members of 'processedVertices' that are neighbors of 'vertex'
        my %new_processed_vertices = map { $_ => 1 } grep { $neighbors{$_} } keys %$processed_vertices;

        # Recursive call with the updated sets
        bron_kerbosch(\@new_cliques, \%new_candidates, \%new_processed_vertices, $graph, $cliques);

        # Move 'vertex' from 'candidates' to 'processedVertices'
        delete $candidates->{$vertex};
        $processed_vertices->{$vertex} = 1;
    }
}

sub max_degree_vertex {
    my ($vertices, $graph) = @_;
    my ($max_vertex, $max_degree) = (undef, -1);

    foreach my $vertex (keys %$vertices) {
        my $degree = scalar @{ $graph->{$vertex} };
        if ($degree > $max_degree) {
            $max_degree = $degree;
            $max_vertex = $vertex;
        }
    }

    return $max_vertex;
}

sub list_comparator {
    my ($list1, $list2) = @_;
    my $min_length = $#$list1 < $#$list2 ? $#$list1 : $#$list2;

    for my $i (0..$min_length) {
        my $comparison = $list1->[$i] cmp $list2->[$i];
        if ($comparison != 0) {
            return $comparison;
        }
    }

    return $#$list1 <=> $#$list2;
}

