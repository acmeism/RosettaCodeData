print "\e7";
loop {
    my $time = DateTime.now;
    put '#' x $_ ~ '.' x (24 - $_) given $time.hour.round;
    put '#' x $_ ~ '.' x (60 - $_) given $time.minute.round;
    put '#' x $_ ~ '.' x (60 - $_) given $time.second.round;
    sleep 1;
    print "\e8";
}
END put "\n";
