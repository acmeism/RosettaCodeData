enum Tile-Type <Empty Mine>;

class Tile {
    has Tile-Type $.type;
    has $.face is rw;
    method Str { $.face // '.' }
}

class Field {
    has Tile @!grid;
    has Int $!width;
    has Int $!height;
    has Int $!mine-spots is rw;
    has Int $!empty-spots is rw;

    method new (Int $width, Int $height, Num $mines-ratio=0.1) {

        my $mine-spots = $width*$height*$mines-ratio;
        my $empty-spots = $width*$height - $mine-spots;

        my @grid;
        for ^$width X ^$height -> $i, $j {
            @grid[$i][$j] = Tile.new(type => Empty);
        }
        for (^$width).pick($mine-spots) Z (^$height).pick($mine-spots) -> $i, $j {
            @grid[$i][$j] = Tile.new( type => Mine);
        }
        self.bless(*, :$width, :$height, :@grid, :$mine-spots, :$empty-spots);
    }

    method open( $i, $j) {
        return if @!grid[$i][$j].face.defined;

        self.end-game("KaBoom") if @!grid[$i][$j].type ~~ Mine;

        my @neighbors = gather take [$i+.[0],$j+.[1]]
            if 0 <= $i + .[0] < $!width && 0 <= $j + .[1] < $!height
             for [-1,-1],[+0,-1],[+1,-1],
                 [-1,+0],(     ),[+1,+0],
                 [-1,+1],[+0,+1],[+1,+1];

        my $mines = [+] @neighbors.map: { @!grid[.[0]][.[1]].type ~~ Mine };

        $!empty-spots--;
        @!grid[$i][$j].face = $mines > 0 ?? $mines !! ' ';

        if $mines == 0 {
            self.open(.[0], .[1]) for @neighbors;
        }
        self.end-game("You won") if $!empty-spots == 0;
    }

    method end-game(Str $msg ) {
        for ^$!width X ^$!height -> $i, $j {
            @!grid[$i][$j].face = '*' if @!grid[$i][$j].type ~~ Mine
        }
        die $msg;
    }

    method mark ( $i, $j) {
        if !@!grid[$i][$j].face.defined {
            @!grid[$i][$j].face = "⚐";
            $!mine-spots-- if @!grid[$i][$j].type ~~ Mine;
        }elsif !@!grid[$i][$j].face eq "⚐" {
            undefine @!grid[$i][$j].face;
            $!mine-spots++ if @!grid[$i][$j].type ~~ Mine;
        }
        self.end-game("You won") if $!mine-spots == 0;
    }

    method Str {
        [~] '┌', '─' xx $!height, "┐\n",
        join '', do for ^$!width -> $i {
            '│', @!grid[$i][*],   "│\n";
        },  '└', '─' xx $!height, '┘';
    }

    method valid ($i, $j) {
        0 <= $i < $!width && 0 <= $j < $!height
    }
}

my $f = Field.new(6,10);

loop {
    say $f;
    my ($c,$x,$y) = prompt("[open|mark] x y: ").split(/\s+/);
    try {
        given $c {
            when !$f.valid($y,$x) { say "invalid coordinates" }
            when 'open' { $f.open($y,$x)   }
            when 'mark' { $f.mark($y,$x)   }
            default     {say "invalid cmd" }
        }
        CATCH {
            say "$!: end of game.";
            return;
        }
    }
    last if $!;
}

say $f;
