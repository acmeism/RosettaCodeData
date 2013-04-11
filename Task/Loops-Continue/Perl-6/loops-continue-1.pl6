for 1 .. 10 {
    .print;
    if $_ %% 5 {
        print "\n";
        next;
    }
    print ', ';
}
