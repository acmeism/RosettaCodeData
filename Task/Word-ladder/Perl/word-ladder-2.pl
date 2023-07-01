use strict;
use warnings;
use feature 'say';

my %dict;
open my $handle, '<', 'ref/unixdict.txt';
while (my $word = <$handle>) {
    chomp $word;
    my $l = length $word;
    if ($dict{$l}) { push @{ $dict{$l} },    $word   }
    else           {         $dict{$l} = \@{[$word]} }
}
close $handle;

sub distance {
    my($w1,$w2) = @_;
    my $d;
    substr($w1, $_, 1) eq substr($w2, $_, 1) or $d++ for 0 .. length($w1) - 1;
    return $d // 0;
}

sub contains {
    my($aref,$needle) = @_;
    $needle eq $_ and return 1 for @$aref;
    return 0;
}

sub word_ladder {
    my($fw,$tw) = @_;
    say 'Nothing like that in dictionary.' and return unless $dict{length $fw};

    my @poss  = @{ $dict{length $fw} };
    my @queue = [$fw];
    while (@queue) {
        my $curr_ref = shift @queue;
        my $last     = $curr_ref->[-1];

        my @next;
        distance($last, $_) == 1 and push @next, $_ for @poss;
        push(@$curr_ref, $tw) and say join ' -> ', @$curr_ref and return if contains \@next, $tw;

        for my $word (@next) {
            $word eq $poss[$_] and splice(@poss, $_, 1) and last for 0 .. @poss - 1;
        }
        push @queue, \@{[@{$curr_ref}, $_]} for @next;
    }

    say "Cannot change $fw into $tw";
}

word_ladder(split) for 'boy man', 'girl lady', 'john jane', 'child adult';
