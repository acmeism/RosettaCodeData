#!/usr/bin/perl
use strict;
use warnings;

# Edge representation
package Edge {
    sub new {
        my ($class, $from, $to) = @_;
        my $self = {
            from => $from,
            to => $to
        };
        bless $self, $class;
        return $self;
    }

    sub from { return $_[0]->{from}; }
    sub to { return $_[0]->{to}; }
}

# Digraph representation
package Digraph {
    sub new {
        my ($class, $vertexCount) = @_;
        die "Number of vertices must be non-negative" if $vertexCount < 0;

        my $self = {
            vertexCount => $vertexCount,
            edgeCount => 0,
            adjacencyLists => []
        };

        # Initialize adjacency lists
        for my $i (0..$vertexCount-1) {
            push @{$self->{adjacencyLists}}, [];
        }

        bless $self, $class;
        return $self;
    }

    sub addEdge {
        my ($self, $from, $to) = @_;
        $self->validateVertex($from);
        $self->validateVertex($to);
        push @{$self->{adjacencyLists}->[$from]}, $to;
        $self->{edgeCount}++;
    }

    sub toString {
        my ($self) = @_;
        my $result = "Digraph has " . $self->{vertexCount} . " vertices and " . $self->{edgeCount} . " edges\nAdjacency lists:\n";

        for my $vertex (0..$self->{vertexCount}-1) {
            my $prefix = ($vertex < 10) ? " $vertex: " : "$vertex: ";
            my @sorted = sort { $a <=> $b } @{$self->{adjacencyLists}->[$vertex]};
            $result .= $prefix . join(" ", @sorted) . "\n";
        }
        return $result;
    }

    sub vertexCount { return $_[0]->{vertexCount}; }
    sub edgeCount { return $_[0]->{edgeCount}; }

    sub adjacencyList {
        my ($self, $vertex) = @_;
        $self->validateVertex($vertex);
        return $self->{adjacencyLists}->[$vertex];
    }

    sub validateVertex {
        my ($self, $vertex) = @_;
        die "Vertex must be between 0 and " . ($self->{vertexCount} - 1) . ": $vertex"
            if $vertex < 0 || $vertex >= $self->{vertexCount};
    }
}

# Stack implementation
package Stack {
    sub new {
        my $class = shift;
        my $self = {
            items => []
        };
        bless $self, $class;
        return $self;
    }

    sub push {
        my ($self, $item) = @_;
        push @{$self->{items}}, $item;
    }

    sub pop {
        my ($self) = @_;
        return pop @{$self->{items}};
    }

    sub peek {
        my ($self) = @_;
        return $self->{items}->[@{$self->{items}} - 1] if @{$self->{items}};
        return undef;
    }

    sub isEmpty {
        my ($self) = @_;
        return @{$self->{items}} == 0;
    }

    sub size {
        my ($self) = @_;
        return scalar @{$self->{items}};
    }
}

# Gabow's Strongly Connected Components Algorithm
package GabowSCC {
    use constant NONE => -1;

    sub new {
        my ($class, $digraph) = @_;

        my $self = {
            visited => [],
            componentIDs => [],
            preorders => [],
            preorderCount => 0,
            sccCount => 0,
            visitedVerticesStack => Stack->new(),
            auxiliaryStack => Stack->new(),
            digraph => $digraph
        };

        bless $self, $class;

        # Initialize arrays
        my $vertexCount = $digraph->vertexCount();
        for my $i (0..$vertexCount-1) {
            push @{$self->{visited}}, 0;
            push @{$self->{componentIDs}}, NONE;
            push @{$self->{preorders}}, NONE;
        }

        # Run DFS for each unvisited vertex
        for my $vertex (0..$vertexCount-1) {
            if (!$self->{visited}->[$vertex]) {
                $self->depthFirstSearch($vertex);
            }
        }

        return $self;
    }

    sub components {
        my ($self) = @_;
        my @components = ();

        # Initialize component arrays
        for my $i (0..$self->{sccCount}-1) {
            push @components, [];
        }

        my $visitedSize = scalar @{$self->{visited}};
        for my $vertex (0..$visitedSize-1) {
            my $componentID = $self->componentID($vertex);
            if ($componentID != NONE) {
                push @{$components[$componentID]}, $vertex;
            } else {
                die "Warning: Vertex $vertex has no SCC ID assigned.";
            }
        }

        return \@components;
    }

    sub isStronglyConnected {
        my ($self, $v, $w) = @_;
        $self->validateVertex($v);
        $self->validateVertex($w);
        return $self->{componentIDs}->[$v] != NONE &&
               $self->{componentIDs}->[$v] == $self->{componentIDs}->[$w];
    }

    sub componentID {
        my ($self, $vertex) = @_;
        $self->validateVertex($vertex);
        return $self->{componentIDs}->[$vertex];
    }

    sub stronglyConnectedComponentCount {
        my ($self) = @_;
        return $self->{sccCount};
    }

    sub depthFirstSearch {
        my ($self, $vertex) = @_;

        $self->{visited}->[$vertex] = 1;
        $self->{preorders}->[$vertex] = $self->{preorderCount};
        $self->{preorderCount}++;
        $self->{visitedVerticesStack}->push($vertex);
        $self->{auxiliaryStack}->push($vertex);

        my $adjList = $self->{digraph}->adjacencyList($vertex);
        for my $w (@$adjList) {
            if (!$self->{visited}->[$w]) {
                $self->depthFirstSearch($w);
            } elsif ($self->{componentIDs}->[$w] == NONE) {
                while (!$self->{auxiliaryStack}->isEmpty() &&
                       $self->{preorders}->[$self->{auxiliaryStack}->peek()] > $self->{preorders}->[$w]) {
                    $self->{auxiliaryStack}->pop();
                }
            }
        }

        if (!$self->{auxiliaryStack}->isEmpty() && $self->{auxiliaryStack}->peek() == $vertex) {
            $self->{auxiliaryStack}->pop();

            while (!$self->{visitedVerticesStack}->isEmpty()) {
                my $w = $self->{visitedVerticesStack}->pop();
                $self->{componentIDs}->[$w] = $self->{sccCount};
                last if $w == $vertex;
            }
            $self->{sccCount}++;
        }
    }

    sub validateVertex {
        my ($self, $vertex) = @_;
        my $visitedCount = scalar @{$self->{visited}};
        die "Vertex $vertex is not between 0 and " . ($visitedCount - 1)
            if $vertex < 0 || $vertex >= $visitedCount;
    }
}

# Main execution
package main {
    # Create edges
    my @edges = (
        Edge->new(4, 2), Edge->new(2, 3), Edge->new(3, 2), Edge->new(6, 0), Edge->new(0, 1),
        Edge->new(2, 0), Edge->new(11, 12), Edge->new(12, 9), Edge->new(9, 10), Edge->new(9, 11),
        Edge->new(8, 9), Edge->new(10, 12), Edge->new(0, 5), Edge->new(5, 4), Edge->new(3, 5),
        Edge->new(6, 4), Edge->new(6, 9), Edge->new(7, 6), Edge->new(7, 8), Edge->new(8, 7),
        Edge->new(5, 3), Edge->new(0, 6)
    );

    # Create digraph
    my $digraph = Digraph->new(13);

    # Add edges
    for my $edge (@edges) {
        $digraph->addEdge($edge->from(), $edge->to());
    }

    print "Constructed digraph:\n";
    print $digraph->toString();

    # Run Gabow's algorithm
    my $gabowSCC = GabowSCC->new($digraph);
    print "It has " . $gabowSCC->stronglyConnectedComponentCount() . " strongly connected components.\n";

    # Get components
    my $components = $gabowSCC->components();
    print "\nComponents:\n";
    for my $i (0..scalar(@$components)-1) {
        my $component = $components->[$i];
        print "Component $i: " . join(" ", @$component) . "\n";
    }

    # Example connectivity checks
    print "\nExample connectivity checks:\n";
    print "Vertices 0 and 3 strongly connected? " .
          ($gabowSCC->isStronglyConnected(0, 3) ? "true" : "false") . "\n";
    print "Vertices 0 and 7 strongly connected? " .
          ($gabowSCC->isStronglyConnected(0, 7) ? "true" : "false") . "\n";
    print "Vertices 9 and 12 strongly connected? " .
          ($gabowSCC->isStronglyConnected(9, 12) ? "true" : "false") . "\n";
    print "Component ID of vertex 5: " . $gabowSCC->componentID(5) . "\n";
    print "Component ID of vertex 8: " . $gabowSCC->componentID(8) . "\n";
}

1;
