use AnyEvent;

# a new condition with a callback:
my $quit = AnyEvent->condvar(
    cb => sub {
        warn "Bye!\n";
    }
);

# a new timer, starts after 2s and repeats every 0.25s:
my $counter = 1;
my $hi = AnyEvent->timer(
    after => 2,
    interval => 0.25,
    cb => sub {
        warn "Hi!\n";
        # flag the condition as ready after 4 times:
        $quit->send if ++$counter > 4;
    }
);

# another timer, runs the callback once after 1s:
my $hello = AnyEvent->timer(
    after => 1,
    cb => sub {
        warn "Hello world!\n";
    }
);

# wait for the $quit condition to be ready:
$quit->recv();
