my $RED = "\e[1;31m";
my $YELLOW = "\e[1;33m";
my $GREEN = "\e[1;32m";
my $CLEAR = "\e[0m";

enum Cell-State <Empty Tree Heating Burning>;
my @pix = '  ', $GREEN ~ '木', $YELLOW ~ '木', $RED ~ '木';

class Forest {
    has Rat $.p = 0.01;
    has Rat $.f = 0.001;
    has Int $!height;
    has Int $!width;
    has @!coords;
    has @!spot;
    has @!neighbors;

    method BUILD (Int :$!height, Int :$!width) {
	@!coords = ^$!height X ^$!width;
	@!spot = [ (Bool.pick ?? Tree !! Empty) xx $!width ] xx $!height;
        self!init-neighbors;
    }

    method !init-neighbors {
        for @!coords -> ($i, $j) {
            @!neighbors[$i][$j] = eager gather for
                    [-1,-1],[+0,-1],[+1,-1],
                    [-1,+0],        [+1,+0],
                    [-1,+1],[+0,+1],[+1,+1]
	    {
		take-rw @!spot[$i + .[0]][$j + .[1]] // next;
	    }
	}
    }

    method step {
	my @heat;
        for @!coords -> ($i, $j) {
            given @!spot[$i][$j] {
                when Empty   { $_ = Tree if rand < $!p }
                when Tree    { $_ = Heating if rand < $!f }
                when Heating { $_ = Burning; push @heat, ($i, $j); }
                when Burning { $_ = Empty }
            }
        }
	for @heat -> ($i,$j) {
	    $_ = Heating for @!neighbors[$i][$j].grep(Tree);
	}
    }

    method show {
        for ^$!height -> $i {
            say @pix[@!spot[$i].list].join;
        }
    }
}

my ($ROWS, $COLS) = qx/stty size/.words;

signal(SIGINT).act: { print "\e[H\e[2J"; exit }

sub MAIN (Int $height = $ROWS - 2, Int $width = +$COLS div 2 - 1) {
    my Forest $forest .= new(:$height, :$width);
    print "\e[2J";      # ANSI clear screen
    loop {
	print "\e[H";   # ANSI home
	say $++;
	$forest.show;
	$forest.step;
    }
}
