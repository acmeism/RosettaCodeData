my $rows = 10;
my $cols = 10;

my $message = q:to/END/;
    .....R....
    ......O...
    .......S..
    ........E.
    T........T
    .A........
    ..C.......
    ...O......
    ....D.....
    .....E....
    END

my %dir =
    '→' => (1,0),
    '↘' => (1,1),
    '↓' => (0,1),
    '↙' => (-1,1),
    '←' => (-1,0),
    '↖' => (-1,-1),
    '↑' => (0,-1),
    '↗' => (1,-1)
;

my @ws = $message.comb(/<print>/);

my $path = './unixdict.txt'; # or wherever

my @words = $path.IO.slurp.words.grep( { $_ !~~ /<-[a..z]>/ and 2 < .chars < 11 } ).pick(*);
my %index;
my %used;

while @ws.first( * eq '.') {

    # find an unfilled cell
    my $i = @ws.grep( * eq '.', :k ).pick;

    # translate the index to x / y coordinates
    my ($x, $y) = $i % $cols, floor($i / $rows);

    # find a word that fits
    my $word = find($x, $y);

    # Meh, reached an impasse, easier to just throw it all
    # away and start over rather than trying to backtrack.
    restart, next unless $word;

    %used{"$word"}++;

    # Keeps trying to place an already used word, choices
    # must be limited, start over
    restart, next if %used{$word} > 15;

    # Already used this word, try again
    next if %index{$word.key};

    # Add word to used word index
    %index ,= $word;

    # place the word into the grid
    place($x, $y, $word);

}

display();

sub display {
    put flat "    ", 'ABCDEFGHIJ'.comb;
    .put for (^10).map: { ($_).fmt("  %2d"), @ws[$_ * $cols .. ($_ + 1) * $cols - 1] }
    put "\n  Words used:";
    my $max = 1 + %index.keys.max( *.chars ).chars;
    for %index.sort {
        printf "%{$max}s %4s %s  ", .key, .value.key, .value.value;
        print "\n" if $++ % 2;
    }
    say "\n"
}

sub restart {
    @ws = $message.comb(/<print>/);
    %index = ();
    %used = ();
}

sub place ($x is copy, $y is copy, $w) {
    my @word = $w.key.comb;
    my $dir  = %dir{$w.value.value};
    @ws[$y * $rows + $x] = @word.shift;
    while @word {
        ($x, $y) »+=« $dir;
        @ws[$y * $rows + $x] = @word.shift;
    }
 }

sub find ($x, $y) {
    my @trials = %dir.keys.map: -> $dir {
            my $space = '.';
            my ($c, $r) = $x, $y;
            loop {
                ($c, $r) »+=« %dir{$dir};
                last if 9 < $r|$c;
                last if 0 > $r|$c;
                my $l = @ws[$r * $rows + $c];
                last if $l ~~ /<:Lu>/;
                $space ~= $l;
            }
            next if $space.chars < 3;
            [$space.trans( '.' => ' ' ),
            ("{'ABCDEFGHIJ'.comb[$x]} {$y}" => $dir)]
        };

    for @words.pick(*) -> $word {
        for @trials -> $space {
            next if $word.chars > $space[0].chars;
            return ($word => $space[1]) if compare($space[0].comb, $word.comb)
        }
    }
}

sub compare (@s, @w) {
    for ^@w {
        next if @s[$_] eq ' ';
        return False if @s[$_] ne @w[$_]
    }
    True
}
