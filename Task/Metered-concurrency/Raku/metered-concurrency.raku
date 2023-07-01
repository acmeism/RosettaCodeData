class Semaphore {
    has $.tickets = Channel.new;
    method new ($max) {
        my $s = self.bless;
        $s.tickets.send(True) xx $max;
        $s;
    }
    method acquire { $.tickets.receive }
    method release { $.tickets.send(True) }
}

sub MAIN ($units = 5, $max = 2) {
    my $sem = Semaphore.new($max);

    my @units = do for ^$units -> $u {
        start {
            $sem.acquire; say "unit $u acquired";
            sleep 2;
            $sem.release; say "unit $u released";
        }
    }
    await @units;
}
