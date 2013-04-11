enum Dir < north northeast east southeast south southwest west northwest >;
my $debug = 0;

class Turtle {
    has @.loc = 0,0;
    has Dir $.dir = north;

    my @dv =  [0,-1], [1,-1], [1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1];
    my @num-to-dir = Dir.invert.sort».value;
    my $points = +Dir;

    my %world;
    my $maxegg;
    my $range-x;
    my $range-y;

    method turn-left ($angle = 90) { $!dir -= $angle / 45; $!dir %= $points; }
    method turn-right($angle = 90) { $!dir += $angle / 45; $!dir %= $points; }

    method lay-egg($egg) {
	%world{~@!loc} = $egg;
	$maxegg max= $egg;
	$range-x minmax= @!loc[0];
	$range-y minmax= @!loc[1];
    }

    method look($ahead = 1) {
	my $there = @!loc »+« (@dv[$!dir] X* $ahead);
	say "looking @num-to-dir[$!dir] to $there" if $debug;
	%world{~$there};
    }

    method forward($ahead = 1) {
	my $there = @!loc »+« (@dv[$!dir] X* $ahead);
	@!loc = @($there);
	say " moving @num-to-dir[$!dir] to @!loc[]" if $debug;
    }

    method showmap() {
	my $form = "%{$maxegg.chars}s";
	my $endx = $range-x.max;
    	for $range-y.list X $range-x.list -> $y, $x {
	    print (%world{"$x $y"} // '').fmt($form);
	    print $x == $endx ?? "\n" !! ' ';
	}
    }
}
