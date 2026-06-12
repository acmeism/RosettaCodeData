my @chars = ( @*ARGS[0] ?? @*ARGS[0].IO.slurp !! q:to/BOB/ ) .lc.comb: /\w/;
    Lyrics to "Bob" copyright Weird Al Yankovic
    https://www.youtube.com/watch?v=JUQDzj6R3p4

    I, man, am regal - a German am I
    Never odd or even
    If I had a hi-fi
    Madam, I'm Adam
    Too hot to hoot
    No lemons, no melon
    Too bad I hid a boot
    Lisa Bonet ate no basil
    Warsaw was raw
    Was it a car or a cat I saw?

    Rise to vote, sir
    Do geese see God?
    "Do nine men interpret?" "Nine men," I nod
    Rats live on no evil star
    Won't lovers revolt now?
    Race fast, safe car
    Pa's a sap
    Ma is as selfless as I am
    May a moody baby doom a yam?

    Ah, Satan sees Natasha
    No devil lived on
    Lonely Tylenol
    Not a banana baton
    No "x" in "Nixon"
    O, stone, be not so
    O Geronimo, no minor ego
    "Naomi," I moan
    "A Toyota's a Toyota"
    A dog, a panic in a pagoda

    Oh no! Don Ho!
    Nurse, I spy gypsies - run!
    Senile felines
    Now I see bees I won
    UFO tofu
    We panic in a pew
    Oozy rat in a sanitary zoo
    God! A red nugget! A fat egg under a dog!
    Go hang a salami, I'm a lasagna hog!
    BOB
#"

my @cpfoa = flat
(1 ..^ @chars).race(:1000batch).map: -> \idx {
    my @s;
    for 1, 2 {
       my int ($rev, $fwd) = $_, 1;
       loop {
            quietly last if ($rev > idx) || (@chars[idx - $rev] ne @chars[idx + $fwd]);
            $rev = $rev + 1;
            $fwd = $fwd + 1;
        }
        @s.push: @chars[idx - $rev ^..^ idx + $fwd].join if $rev + $fwd > 2;
        last if @chars[idx - 1] ne @chars[idx];
    }
    next unless +@s;
    @s
}

"{.key} ({+.value})\t{.value.unique.sort}".put for @cpfoa.classify( *.chars ).sort( -*.key ).head(5);
