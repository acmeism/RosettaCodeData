use strict;
use English;
use Smart::Comments;

my @ex1 = consolidate( (['A', 'B'], ['C', 'D']) );
### Example 1: @ex1
my @ex2 = consolidate( (['A', 'B'], ['B', 'D']) );
### Example 2: @ex2
my @ex3 = consolidate( (['A', 'B'], ['C', 'D'], ['D', 'B']) );
### Example 3: @ex3
my @ex4 = consolidate( (['H', 'I', 'K'], ['A', 'B'], ['C', 'D'], ['D', 'B'], ['F', 'G', 'H']) );
### Example 4: @ex4
exit 0;

sub consolidate {
    scalar(@ARG) >= 2 or return @ARG;
    my @result = ( shift(@ARG) );
    my @recursion = consolidate(@ARG);
    foreach my $r (@recursion) {
        if (set_intersection($result[0], $r)) {
            $result[0] = [ set_union($result[0], $r) ];
        }
        else {
            push @result, $r;
        }
    }
    return @result;
}

sub set_union {
    my ($a, $b) = @ARG;
    my %union;
    foreach my $a_elt (@{$a}) { $union{$a_elt}++; }
    foreach my $b_elt (@{$b}) { $union{$b_elt}++; }
    return keys(%union);
}

sub set_intersection {
    my ($a, $b) = @ARG;
    my %a_hash;
    foreach my $a_elt (@{$a}) { $a_hash{$a_elt}++; }
    my @result;
    foreach my $b_elt (@{$b}) {
        push(@result, $b_elt) if exists($a_hash{$b_elt});
    }
    return @result;
}
