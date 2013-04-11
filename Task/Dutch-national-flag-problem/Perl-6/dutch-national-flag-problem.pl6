enum NL <red white blue>;
my @colors;

sub how'bout (&this-way) {
    sub show {
        say @colors;
        say "Ordered: ", [<=] @colors;
    }

    @colors = NL.roll(20);
    show;
    this-way;
    show;
    say '';
}

say "Using functional sort";
how'bout { @colors = sort *.value, @colors }

say "Using in-place sort";
how'bout { @colors .= sort: *.value }

say "Using a Bag";
how'bout { @colors = red, white, blue Zxx bag(@colors».key)<red white blue> }

say "Using the classify method";
how'bout { @colors = (.list for %(@colors.classify: *.value){0,1,2}) }

say "Using multiple greps";
how'bout { @colors = (.grep(red), .grep(white), .grep(blue) given @colors) }
