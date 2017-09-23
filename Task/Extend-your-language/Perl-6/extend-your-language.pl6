my &if2  = -> \a, \b, &x { my @*IF2 = ?a,?b; x }

my &if-both    = -> &x { x if @*IF2 eq (True,True)  }
my &if-first   = -> &x { x if @*IF2 eq (True,False) }
my &if-second  = -> &x { x if @*IF2 eq (False,True) }
my &if-neither = -> &x { x if @*IF2 eq (False,False)}

sub test ($a,$b) {
    $_ = "G";          # Demo correct scoping of topic.
    my $got = "o";     # Demo correct scoping of lexicals.
    my $*got = "t";    # Demo correct scoping of dynamics.

    if2 $a, $b, {
        if-both { say "$_$got$*got both" }
        if-first { say "$_$got$*got first" }
        if-second { say "$_$got$*got second" }
        if-neither { say "$_$got$*got neither" }
    }
}

say test |$_ for 1,0 X 1,0;
