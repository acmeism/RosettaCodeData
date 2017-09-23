class Turtle {
    my @dv =  [0,-1], [1,-1], [1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1];
    my $points = 8; # 'compass' points of neighbors on grid: north=0, northeast=1, east=2, etc.

    has @.loc = 0,0;
    has $.dir = 0;
    has %.world;
    has $.maxegg;
    has $.range-x;
    has $.range-y;

    method turn-left ($angle = 90) { $!dir -= $angle / 45; $!dir %= $points; }
    method turn-right($angle = 90) { $!dir += $angle / 45; $!dir %= $points; }

    method lay-egg($egg) {
    %!world{~@!loc} = $egg;
    $!maxegg max= $egg;
    $!range-x minmax= @!loc[0];
    $!range-y minmax= @!loc[1];
    }

    method look($ahead = 1) {
    my $there = @!loc »+« @dv[$!dir] »*» $ahead;
    %!world{~$there};
    }

    method forward($ahead = 1) {
    my $there = @!loc »+« @dv[$!dir] »*» $ahead;
    @!loc = @($there);
    }

    method showmap() {
    my $form = "%{$!maxegg.chars}s";
    my $endx = $!range-x.max;
        for $!range-y.list X $!range-x.list -> ($y, $x) {
        print (%!world{"$x $y"} // '').fmt($form);
        print $x == $endx ?? "\n" !! ' ';
    }
    }
}
