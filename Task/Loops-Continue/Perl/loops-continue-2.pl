foreach (1..10) {
    print $_;
    if ($_ % 5 == 0) {
        print "\n";
        goto MYLABEL;
    }
    print ', ';
MYLABEL:
}
