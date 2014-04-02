enum Color (red => 0o1000, green =>  0o2000, purple => 0o4000);
enum Count (one =>  0o100, two =>     0o200, three =>   0o400);
enum Shape (oval =>  0o10, squiggle => 0o20, diamond =>  0o40);
enum Style (solid =>  0o1, open =>      0o2, striped =>   0o4);

my @deck := (Color.enums X Count.enums X Shape.enums X Style.enums).tree;

sub MAIN($DRAW = 9, $GOAL = $DRAW div 2) {
    sub show-cards(@c) { printf "    %-6s %-5s %-8s %s\n", $_».key for @c }

    my @combinations = [^$DRAW].combinations(3);

    my @draw;
    repeat until (my @sets) == $GOAL {
        @draw = @deck.pick($DRAW);
        my @bits = @draw.map: { [+] @^enums».value }
        @sets = gather for @combinations -> @c {
            take @draw[@c].item when /^ <[1247]>+ $/ given ( [+|] @bits[@c] ).base(8);
        }
    }

    say "Drew $DRAW cards:";
    show-cards @draw;
    for @sets.kv -> $i, @cards {
        say "\nSet {$i+1}:";
        show-cards @cards;
    }
}
