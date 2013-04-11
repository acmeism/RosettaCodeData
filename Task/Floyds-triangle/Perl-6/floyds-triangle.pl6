sub chunk(@flat is copy, *@size) {
    gather for @size -> $s { take [@flat.shift xx $s] }
}

constant @floyd = chunk 1..*, 1..*;

sub say-floyd($n) {
    my @fmt = @floyd[$n-1].map: {"%{.chars}s"}

    for @floyd[^$n] -> @i {
        say join ' ', (@i Z @fmt).map: -> $i, $f { $i.fmt($f) }
    }
}

say-floyd 5;
say-floyd 14;
