sub insert($x, @xs) { [@xs[0..$_-1], $x, @xs[$_..*]] for 0..+@xs }
sub order($sg, @xs) { $sg > 0 ?? @xs !! @xs.reverse }

multi perms([]) {
    [] => +1
}

multi perms([$x, *@xs]) {
    perms(@xs).map({ order($_.value, insert($x, $_.key)) }) Z=> (+1,-1) xx *
}

.say for perms([0..2]);
