my @a = [ (1..20).roll(10) ] xx *;

LINE: for @a -> @line {
    for @line -> $elem {
        print " $elem";
        last LINE if $elem == 20;
    }
    print "\n";
}
print "\n";
