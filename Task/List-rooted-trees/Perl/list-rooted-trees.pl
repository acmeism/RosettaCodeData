use strict;
use warnings;
use feature 'say';

sub bagchain {
    my($x, $n, $bb, $start) = @_;
    return [@$x] unless $n;

    my @sets;
    $start //= 0;
    for my $i ($start .. @$bb-1) {
        my($c, $s) = @{$$bb[$i]};
        push @sets, bagchain([$$x[0] + $c, $$x[1] . $s], $n-$c, $bb, $i) if $c <= $n
    }
    @sets
}

sub bags {
    my($n) = @_;
    return [0, ''] unless $n;

    my(@upto,@sets);
    push @upto, bags($_) for reverse 1 .. $n-1;
    for ( bagchain([0, ''], $n-1, \@upto) ) {
        my($c,$s) = @$_;
        push @sets, [$c+1, '(' . $s . ')']
    }
    @sets;
}

sub replace_brackets {
    my $bags;
    my $depth = 0;
    for my $b (split //, $_[0]) {
        if ($b eq '(') { $bags .= (qw<( [ {>)[$depth++ % 3] }
        else           { $bags .= (qw<) ] }>)[--$depth % 3] }
    }
    $bags
}

say replace_brackets $$_[1] for bags(5);
