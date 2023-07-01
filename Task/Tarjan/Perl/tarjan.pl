use strict;
use warnings;
use feature <say state current_sub>;
use List::Util qw(min);

sub tarjan {
    my (%k) = @_;
    my (%onstack, %index, %lowlink, @stack, @connected);

    my sub strong_connect {
        my ($vertex, $i) = @_;
        $index{$vertex}   = $i;
        $lowlink{$vertex} = $i + 1;
        $onstack{$vertex} = 1;
        push @stack, $vertex;
        for my $connection (@{$k{$vertex}}) {
            if (not defined $index{$connection}) {
                __SUB__->($connection, $i + 1);
                $lowlink{$vertex} = min($lowlink{$connection}, $lowlink{$vertex});
            }
            elsif ($onstack{$connection}) {
                $lowlink{$vertex} = min($index{$connection}, $lowlink{$vertex});
            }
        }
        if ($lowlink{$vertex} eq $index{$vertex}) {
            my @node;
            do {
                push @node, pop @stack;
                $onstack{$node[-1]} = 0;
            } while $node[-1] ne $vertex;
            push @connected, [@node];
        }
    }

    for (sort keys %k) {
        strong_connect($_, 0) unless $index{$_};
    }
    @connected;
}

my %test1 = (
             0 => [1],
             1 => [2],
             2 => [0],
             3 => [1, 2, 4],
             4 => [3, 5],
             5 => [2, 6],
             6 => [5],
             7 => [4, 6, 7]
            );

my %test2 = (
             'Andy' => ['Bart'],
             'Bart' => ['Carl'],
             'Carl' => ['Andy'],
             'Dave' => [qw<Bart Carl Earl>],
             'Earl' => [qw<Dave Fred>],
             'Fred' => [qw<Carl Gary>],
             'Gary' => ['Fred'],
             'Hank' => [qw<Earl Gary Hank>]
            );

print "Strongly connected components:\n";
print join(', ', sort @$_) . "\n" for tarjan(%test1);
print "\nStrongly connected components:\n";
print join(', ', sort @$_) . "\n" for tarjan(%test2);
