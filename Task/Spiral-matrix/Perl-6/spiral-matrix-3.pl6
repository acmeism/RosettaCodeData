sub MAIN($size as Int) {
my $t = Turtle.new(dir => ($size %% 2 ?? 4 !! 0));
my $counter = $size * $size;
while $counter {
    $t.lay-egg(--$counter);
    $t.turn-left;
    $t.turn-right if $t.look;
    $t.forward;
}
$t.showmap;
}
