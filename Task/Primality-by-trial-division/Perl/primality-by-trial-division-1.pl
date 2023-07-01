sub prime { my $n = shift || $_;
    $n % $_ or return for 2 .. sqrt $n;
    $n > 1
}

print join(', ' => grep prime, 1..100), "\n";
