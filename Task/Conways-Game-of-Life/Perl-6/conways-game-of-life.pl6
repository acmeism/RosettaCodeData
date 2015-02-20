class Automaton {
    subset World of Str where {
	.lines>>.chars.uniq == 1 and m/^^<[.#\n]>+$$/
    }
    has Int ($.width, $.height);
    has @.a;

    multi method new (World $s) {
	self.new:
	:width(.pick.chars), :height(.elems),
	:a( .map: { [ .comb ] } )
        given $s.lines;
    }

    method gist { join "\n", map { [~] @$_ }, @!a }

    method C (Int $r, Int $c --> Bool) {
	@!a[$r % $!height][$c % $!width] eq '#';
    }
    method N (Int $r, Int $c --> Int) {
	+grep ?*, map { self.C: |@$_ },
	[ $r - 1, $c - 1], [ $r - 1, $c ], [ $r - 1, $c + 1],
	[ $r    , $c - 1],                 [ $r    , $c + 1],
	[ $r + 1, $c - 1], [ $r + 1, $c ], [ $r + 1, $c + 1];
    }

    method succ {
	self.new: :$!width, :$!height,
	:a(
	    gather for ^$.height -> $r {
		take [
		    gather for ^$.width -> $c {
			take
			(self.C($r, $c) == 1 && self.N($r, $c) == 2|3 )
			|| (self.C($r, $c) == 0 && self.N($r, $c) == 3)
			?? '#' !! '.'
		    }
		]
	    }
	)
    }
}

my Automaton $glider .= new: '............
............
............
.......###..
.......#....
........#...
............';


for ^10 {
    say $glider++;
    say '--';
}
