use AnyEvent;

my $quit = AE::cv sub { warn "Bye!\n" };

my $counter = 1;
my $hi = AE::timer 2, 0.25, sub {
    warn "Hi!\n";
    $quit->send if ++$counter > 4;
};

my $hello = AE::timer 1, 0, sub {
    warn "Hello world!\n";
};

$quit->recv;
