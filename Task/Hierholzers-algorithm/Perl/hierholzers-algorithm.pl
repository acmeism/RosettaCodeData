use strict;
use warnings;

sub print_circuit {
    my ($adjacency_list) = @_;

    return if !@$adjacency_list;

    my @path;
    my @circuit;

    my $current_vertex = 0; # Start at vertex 0
    push @path, $current_vertex;

    while (@path) {
        if (@{$adjacency_list->[$current_vertex]}) {
            push @path, $current_vertex;
            my $next_vertex = pop @{$adjacency_list->[$current_vertex]};
            $current_vertex = $next_vertex;
        } else {
            push @circuit, $current_vertex;
            $current_vertex = pop @path;
        }
    }

    # Print the circuit
    for my $i (reverse 0..$#circuit) {
        print $circuit[$i];
        print " => " if $i != 0;
    }
    print "\n";
}

my @adjacency_list1 = (
    [1],
    [2],
    [0]
);

print_circuit(\@adjacency_list1);

my @adjacency_list2 = (
    [1, 6],
    [2],
    [0, 3],
    [4],
    [2, 5],
    [0],
    [4]
);

print_circuit(\@adjacency_list2);

