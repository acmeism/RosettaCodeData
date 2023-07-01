sub repeat {
    my ($sub, $n) = @_;
    $sub->() for 1..$n;
}

sub example {
    print "Example\n";
}

repeat(\&example, 4);
