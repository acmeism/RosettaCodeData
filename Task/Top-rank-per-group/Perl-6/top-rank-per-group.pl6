my @data = (
    [< E10297 32000 D101 Tyler_Bennett   >],
    [< E21437 47000 D050 John_Rappl      >],
    [< E00127 53500 D101 George_Woltman  >],
    [< E63535 18000 D202 Adam_Smith      >],
    [< E39876 27800 D202 Claire_Buckman  >],
    [< E04242 41500 D101 David_McClellan >],
    [< E01234 49500 D202 Rich_Holcomb    >],
    [< E41298 21900 D050 Nathan_Adams    >],
    [< E43128 15900 D101 Richard_Potter  >],
    [< E27002 19250 D202 David_Motsinger >],
    [< E03033 27000 D101 Tim_Sampair     >],
    [< E10001 57000 D190 Kim_Arlich      >],
    [< E16398 29900 D190 Timothy_Grove   >],
).map: { item %( < id salary dept name > Z=> .list ) }

sub MAIN($N as Int = 3) {
    my $cont = 0;
    for @data.classify({ .<dept> }).sort».value {
        my @es = .sort({ -.<salary> });
        print "\n" if $cont++;
        say .< dept id salary name >.Str if .so for @es[^$N];
    }
}
