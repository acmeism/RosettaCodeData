sub hash-join(@a, &a, @b, &b) {
    my %hash := @b.classify(&b);

    @a.map: -> $a {
        |(%hash{$a.&a} // next).map: -> $b { [$a, $b] }
    }
}

my @A =
    [27, "Jonah"],
    [18, "Alan"],
    [28, "Glory"],
    [18, "Popeye"],
    [28, "Alan"],
;

my @B =
    ["Jonah", "Whales"],
    ["Jonah", "Spiders"],
    ["Alan", "Ghosts"],
    ["Alan", "Zombies"],
    ["Glory", "Buffy"],
;

.say for hash-join @A, *[1], @B, *[0];
