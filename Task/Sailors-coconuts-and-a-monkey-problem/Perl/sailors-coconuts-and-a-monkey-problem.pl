use bigint;

for $sailors (1..15) { check( $sailors, coconuts( 0+$sailors ) ) }

sub is_valid {
    my($sailors, $nuts) = @_;
    return 0, 0 if $sailors == 1 and $nuts == 1;
    my @shares;
    for (1..$sailors) {
        return () unless ($nuts % $sailors) == 1;
        push @shares, int ($nuts-1)/$sailors;
        $nuts -= (1 + int $nuts/$sailors);
    }
    push @shares, int $nuts/$sailors;
    return @shares if !($nuts % $sailors);
}

sub check {
    my($sailors, $coconuts) = @_;
    my @suffix = ('th', 'st', 'nd', 'rd', ('th') x 6, ('th') x 10);
    my @piles = is_valid($sailors, $coconuts);
    if (@piles) {
        print "\nSailors $sailors: Coconuts $coconuts:\n";
        for my $k (0..-1 + $#piles) {
             print $k+1 . $suffix[$k+1] . " takes " . $piles[$k] . ", gives 1 to the monkey.\n"
        }
        print "The next morning, each sailor takes " . $piles[-1] . "\nwith none left over for the monkey.\n";
        return 1
    }
    return 0
}

sub coconuts {
    my($sailors) = @_;
    if ($sailors % 2 == 0 ) { ($sailors ** $sailors - 1) * ($sailors - 1) }
    else                    {  $sailors ** $sailors      -  $sailors + 1  }
}
