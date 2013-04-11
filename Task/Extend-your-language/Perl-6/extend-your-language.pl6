my &if2  = -> \a, \b, &x { my @*IF2 = ?a,?b; x }

my &if-both    = -> &x { x if @*IF2 ~~ (True,True)  }
my &if-first   = -> &x { x if @*IF2 ~~ (True,False) }
my &if-second  = -> &x { x if @*IF2 ~~ (False,True) }
my &if-neither = -> &x { x if @*IF2 ~~ (False,False)}

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

test 1,1;
test 1,0;
test 0,1;
test 0,0;
