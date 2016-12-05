sub say-floyd($n) {
    my @formats = @floyd[$n-1].map: {"%{.chars}s"}

    for @floyd[^$n] -> @i {
        say ~(@i Z @formats).map: -> ($i, $f) { $i.fmt($f) }
    }
}

say-floyd 5;
say-floyd 14;
