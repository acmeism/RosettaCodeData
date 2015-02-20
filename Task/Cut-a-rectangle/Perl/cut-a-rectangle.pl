use strict;
use warnings;
my @grid = 0;

my ($w, $h, $len);
my $cnt = 0;

my @next;
my @dir = ([0, -1], [-1, 0], [0, 1], [1, 0]);

sub walk {
    my ($y, $x) = @_;

    if (!$y || $y == $h || !$x || $x == $w) {
	$cnt += 2;
	return;
    }

    my $t = $y * ($w + 1) + $x;
    $grid[$_]++ for $t, $len - $t;

    for my $i (0 .. 3) {
	if (!$grid[$t + $next[$i]]) {
	    walk($y + $dir[$i]->[0], $x + $dir[$i]->[1]);
	}
    }

    $grid[$_]-- for $t, $len - $t;
}

sub solve {
    my ($hh, $ww, $recur) = @_;
    my ($t, $cx, $cy, $x);
    ($h, $w) = ($hh, $ww);

    if ($h & 1) { ($t, $w, $h) = ($w, $h, $w); }
    if ($h & 1) { return 0; }
    if ($w == 1) { return 1; }
    if ($w == 2) { return $h; }
    if ($h == 2) { return $w; }

    {
	use integer;
	($cy, $cx) = ($h / 2, $w / 2);
    }

    $len = ($h + 1) * ($w + 1);
    @grid = ();
    $grid[$len--] = 0;

    @next = (-1, -$w - 1, 1, $w + 1);

    if ($recur) { $cnt = 0; }
    for ($x = $cx + 1; $x < $w; $x++) {
	$t = $cy * ($w + 1) + $x;
	@grid[$t, $len - $t] = (1, 1);
	walk($cy - 1, $x);
    }
    $cnt++;

    if ($h == $w) {
	$cnt *= 2;
    } elsif (!($w & 1) && $recur) {
	solve($w, $h);
    }

    return $cnt;
}

sub MAIN {
    print "ok\n";
    my ($y, $x);
    for my $y (1 .. 10) {
	for my $x (1 .. $y) {
	    if (!($x & 1) || !($y & 1)) {
		printf("%d x %d: %d\n", $y, $x, solve($y, $x, 1));
	    }
	}
    }
}

MAIN();
