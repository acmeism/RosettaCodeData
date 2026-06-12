#!/usr/bin/perl
use strict;
use warnings;

package Node;

sub new {
    my $class = shift;
    my $self = {
        sub => "",    # a substring of the input string
        ch => []      # list of child nodes
    };
    bless $self, $class;
    return $self;
}

package SuffixTree;

sub new {
    my ($class, $str) = @_;
    my $self = {
        nodes => []
    };
    bless $self, $class;

    # Add root node
    push @{$self->{nodes}}, Node->new();

    # Add all suffixes
    for my $i (0 .. length($str) - 1) {
        $self->addSuffix(substr($str, $i));
    }

    return $self;
}

sub addSuffix {
    my ($self, $suf) = @_;
    my $n = 0;
    my $i = 0;

    while ($i < length($suf)) {
        my $b = substr($suf, $i, 1);
        my $children = $self->{nodes}->[$n]->{ch};
        my $x2 = 0;
        my $n2;

        while (1) {
            if ($x2 == @$children) {
                # no matching child, remainder of suf becomes new node
                $n2 = @{$self->{nodes}};
                my $temp = Node->new();
                $temp->{sub} = substr($suf, $i);
                push @{$self->{nodes}}, $temp;
                push @$children, $n2;
                return;
            }
            $n2 = $children->[$x2];
            if (substr($self->{nodes}->[$n2]->{sub}, 0, 1) eq $b) {
                last;
            }
            $x2++;
        }

        # find prefix of remaining suffix in common with child
        my $sub2 = $self->{nodes}->[$n2]->{sub};
        my $j = 0;

        while ($j < length($sub2)) {
            if (substr($suf, $i + $j, 1) ne substr($sub2, $j, 1)) {
                # split n2
                my $n3 = $n2;
                # new node for the part in common
                $n2 = @{$self->{nodes}};
                my $temp = Node->new();
                $temp->{sub} = substr($sub2, 0, $j);
                push @{$temp->{ch}}, $n3;
                push @{$self->{nodes}}, $temp;
                $self->{nodes}->[$n3]->{sub} = substr($sub2, $j);  # old node loses the part in common
                $self->{nodes}->[$n]->{ch}->[$x2] = $n2;
                last;  # continue down the tree
            }
            $j++;
        }
        $i += $j;  # advance past part in common
        $n = $n2;  # continue down the tree
    }
}

sub visualize {
    my $self = shift;

    if (@{$self->{nodes}} == 0) {
        print "<empty>\n";
        return;
    }
    $self->visualize_f(0, "");
}

sub visualize_f {
    my ($self, $n, $pre) = @_;
    my $children = $self->{nodes}->[$n]->{ch};

    if (@$children == 0) {
        print "- " . $self->{nodes}->[$n]->{sub} . "\n";
        return;
    }

    print "┐ " . $self->{nodes}->[$n]->{sub} . "\n";

    for my $i (0 .. @$children - 2) {
        my $c = $children->[$i];
        print $pre . "├─";
        $self->visualize_f($c, $pre . "│ ");
    }

    print $pre . "└─";
    $self->visualize_f($children->[@$children - 1], $pre . "  ");
}

# Main execution
package main;

my $tree = SuffixTree->new("banana\$");
$tree->visualize();
