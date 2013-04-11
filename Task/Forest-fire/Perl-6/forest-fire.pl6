constant RED = "\e[1;31m";
constant CLEAR = "\e[0m";

enum Cell-State <Empty Tree Burning>;
my @show = ('  ', '木', RED ~ '木' ~ CLEAR);

class Forest {
    has Cell-State @!grid;
    has @!neighbors;
    has Int $.height;
    has Int $.width;
    has $.p;
    has $.f;

    method new(Int $height, Int $width, $p=0.01, $f=0.001) {
        my $c = self.bless(*, :$height, :$width, :$p, :$f);
        $c!init-grid;
        $c!init-neighbors;
        return $c;
    }

    method !init-grid {
	@!grid = [ (Bool.pick ?? Tree !! Empty) xx $!width ] xx $!height;
    }

    method !init-neighbors {
        for ^$!height X ^$!width -> $i, $j {
            @!neighbors[$i][$j] = gather for
                    [-1,-1],[+0,-1],[+1,-1],
                    [-1,+0],(     ),[+1,+0],
                    [-1,+1],[+0,+1],[+1,+1]
	    {
		take-rw @!grid[$i + .[0]][$j + .[1]] // next;
	    }
        }
    }

    method step {
        my @new;
        for ^$!height X ^$!width -> $i, $j {
            given @!grid[$i][$j] {
                when Empty   { @new[$i][$j] = rand < $!p ?? Tree !! Empty }
                when Tree    { @new[$i][$j] =
                     (@!neighbors[$i][$j].any === Burning or rand < $!f) ?? Burning !! Tree;
                }
                when Burning { @new[$i][$j] = Empty }
            }
        }
        for ^$!height X ^$!width -> $i, $j {
            @!grid[$i][$j] = @new[$i][$j];
        }
    }

    method Str {
        join '', gather for ^$!height -> $i {
            take @show[@!grid[$i].list], "\n";
        }
    }
}

my Forest $f .= new(20,30);
print "\e[2J";      # ANSI clear screen

my $i = 0;
loop {
    print "\e[H";   # ANSI home
    say $i++;
    say $f.Str;
    $f.step;
}
