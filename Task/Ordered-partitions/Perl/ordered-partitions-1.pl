use strict;
use warnings;
use Thread 'async';
use Thread::Queue;

sub make_slices {
        my ($n, @avail) = (shift, @{ +shift });

        my ($q, @part, $gen);
        $gen = sub {
                my $pos = shift;        # where to start in the list
                if (@part == $n) {
                        # we accumulated enough for a partition, emit them and
                        # wait for main thread to pick them up, then back up
                        $q->enqueue(\@part, \@avail);
                        return;
                }

                # obviously not enough elements left to make a partition, back up
                return if (@part + @avail < $n);

                for my $i ($pos .. @avail - 1) {                # try each in turn
                        push @part, splice @avail, $i, 1;       # take one
                        $gen->($i);                             # go deeper
                        splice @avail, $i, 0, pop @part;        # put it back
                }
        };

        $q = Thread::Queue->new;
        (async{ &$gen;                  # start the main work load
                $q->enqueue(undef)      # signal that there's no more data
        })->detach;     # let the thread clean up after itself, not my problem

        return $q;
}

my $qa = make_slices(4, [ 0 .. 9 ]);
while (my $a = $qa->dequeue) {
        my $qb = make_slices(2, $qa->dequeue);

        while (my $b = $qb->dequeue) {
                my $rb = $qb->dequeue;
                print "@$a | @$b | @$rb\n";
        }
}
