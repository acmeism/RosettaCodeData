my @doors;
for my $pass (1 .. 100) {
    for (1 .. 100) {
        if (0 == $_ % $pass) {
            $doors[$_] = not $doors[$_];
        };
    };
};

print "Door $_ is ", $doors[$_] ? "open" : "closed", "\n" for 1 .. 100;
