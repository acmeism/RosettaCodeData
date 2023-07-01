use strict;
use warnings;

my %dict;

open my $handle, '<', 'unixdict.txt';
while (my $word = <$handle>) {
    chomp($word);
    my $len = length $word;
    if (exists $dict{$len}) {
        push @{ $dict{ $len } }, $word;
    } else {
        my @words = ( $word );
        $dict{$len} = \@words;
    }
}
close $handle;

sub distance {
    my $w1 = shift;
    my $w2 = shift;

    my $dist = 0;
    for my $i (0 .. length($w1) - 1) {
        my $c1 = substr($w1, $i, 1);
        my $c2 = substr($w2, $i, 1);
        if (not ($c1 eq $c2)) {
            $dist++;
        }
    }
    return $dist;
}

sub contains {
    my $aref = shift;
    my $needle = shift;

    for my $v (@$aref) {
        if ($v eq $needle) {
            return 1;
        }
    }

    return 0;
}

sub word_ladder {
    my $fw = shift;
    my $tw = shift;

    if (exists $dict{length $fw}) {
        my @poss = @{ $dict{length $fw} };
        my @queue = ([$fw]);
        while (scalar @queue > 0) {
            my $curr_ref = shift @queue;
            my $last = $curr_ref->[-1];

            my @next;
            for my $word (@poss) {
                if (distance($last, $word) == 1) {
                    push @next, $word;
                }
            }

            if (contains(\@next, $tw)) {
                push @$curr_ref, $tw;
                print join (' -> ', @$curr_ref), "\n";
                return;
            }

            for my $word (@next) {
                for my $i (0 .. scalar @poss - 1) {
                    if ($word eq $poss[$i]) {
                        splice @poss, $i, 1;
                        last;
                    }
                }
            }

            for my $word (@next) {
                my @temp = @$curr_ref;
                push @temp, $word;

                push @queue, \@temp;
            }
        }
    }

    print STDERR "Cannot change $fw into $tw\n";
}

word_ladder('boy', 'man');
word_ladder('girl', 'lady');
word_ladder('john', 'jane');
word_ladder('child', 'adult');
word_ladder('cat', 'dog');
word_ladder('lead', 'gold');
word_ladder('white', 'black');
word_ladder('bubble', 'tickle');
