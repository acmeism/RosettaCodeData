constant @floyd1 = (1..*).rotor(1..*);
constant @floyd2 = gather for 1..* -> $s { take [++$ xx $s] }

sub format-rows(@f) {
    my @table;
    my @formats = @f[@f-1].map: {"%{.chars}s"}
    for @f -> @row {
        @table.push: (@row Z @formats).map: -> ($i, $f) { $i.fmt($f) }
    }
    join "\n", @table;
}

say format-rows(@floyd1[^5]);
say '';
say format-rows(@floyd2[^14]);
