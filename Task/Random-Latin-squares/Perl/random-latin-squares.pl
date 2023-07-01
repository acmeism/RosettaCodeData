use strict;
use warnings;
use feature 'say';
use List::Util 'shuffle';

sub random_ls {
    my($n) = @_;
    my(@cols,@symbols,@ls_sym);

    # build n-sized latin square
    my @ls = [0,];
    for my $i (1..$n-1) {
        @{$ls[$i]} = @{$ls[0]};
        splice(@{$ls[$_]}, $_, 0, $i) for 0..$i;
    }

    # shuffle rows and columns
    @cols = shuffle 0..$n-1;
    @ls = map [ @{$_}[@cols] ], @ls[shuffle 0..$n-1];

    # replace numbers with symbols
    @symbols = shuffle( ('A'..'Z')[0..$n-1] );
    push @ls_sym, [@symbols[@$_]] for @ls;
    @ls_sym
}

sub display {
    my $str;
    $str .= join(' ', @$_) . "\n" for @_;
    $str
}

say display random_ls($_) for 2..5, 5;
