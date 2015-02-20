my $RED = "\e[1;31m";
my $YELLOW = "\e[1;33m";
my $GREEN = "\e[1;32m";
my $CLEAR = "\e[0m";

enum Cell-State <Empty Tree Heating Burning>;
my @show = ('  ', $GREEN ~ '木', $YELLOW ~ '木', $RED ~ '木');

class Forest {
    has @!grid;
    has @!neighbors;
    has Int $.height;
    has Int $.width;
    has $.p;
    has $.f;
    has @!cells = ^$!height X ^$!width;

    method new(Int $height, Int $width, $p=0.01, $f=0.001) {
        my $c = self.bless(:$height, :$width, :$p, :$f);
        $c!init-grid;
        $c!init-neighbors;
        return $c;
    }

    method !init-grid {
	@!grid = [ (Bool.pick ?? Tree !! Empty) xx $!width ] xx $!height;
    }

    method !init-neighbors {
        for @!cells -> $i, $j {
            @!neighbors[$i][$j] = eager gather for
                    [-1,-1],[+0,-1],[+1,-1],
                    [-1,+0],(     ),[+1,+0],
                    [-1,+1],[+0,+1],[+1,+1]
	    {
		take-rw @!grid[$i + .[0]][$j + .[1]] // next;
	    }
	}
    }

    method step {
	my @heat;
        for @!cells -> $i, $j {
            given @!grid[$i][$j] {
                when Empty   { @!grid[$i][$j] = rand < $!p ?? Tree !! Empty }
                when Tree    { @!grid[$i][$j] = rand < $!f ?? Heating !! Tree }
                when Heating { @!grid[$i][$j] = Burning; push @heat, $i, $j; }
                when Burning { @!grid[$i][$j] = Empty }
            }
        }
	for @heat -> $i,$j {
	    $_ = Heating for @!neighbors[$i][$j].grep(Tree);
	}
    }

    method show {
        for ^$!height -> $i {
            say @show[@!grid[$i].list].join;
        }
    }
}

my Forest $f .= new(20,30);
print "\e[2J";      # ANSI clear screen

my $i = 0;
loop {
    print "\e[H";   # ANSI home
    say $CLEAR, $i++;
    $f.show;
    $f.step;
}
