sub mangle ($name, $initial) {
    my $fl = $name.lc.substr(0,1);
    $fl ~~ /<[aeiou]>/
    ?? $initial~$name.lc
    !! $fl eq $initial
    ?? $name.substr(1)
    !! $initial~$name.substr(1)
}

sub name-game (Str $name) {
    qq:to/NAME-GAME/;
    $name, $name, bo-{ mangle $name, 'b' }
    Banana-fana fo-{ mangle $name, 'f' }
    Fee-fi-mo-{ mangle $name, 'm' }
    $name!
    NAME-GAME
}

say .&name-game for <Gary Earl Billy Felix Mike Steve>
