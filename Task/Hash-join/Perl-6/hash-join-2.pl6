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
