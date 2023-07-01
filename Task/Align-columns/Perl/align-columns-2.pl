use List::Util qw(max);

sub columns {
    my @lines = map [split /\$/] => split /\n/ => shift;
    my $pos = {qw/left 0 center 1 right 2/}->{+shift};
    for my $col (0 .. max map {$#$_} @lines) {
        my $max = max my @widths = map {length $_->[$col]} @lines;
        for my $row (0 .. $#lines) {
            my @pad = map {' ' x $_, ' ' x ($_ + 0.5)} ($max - $widths[$row]) / 2;
            for ($lines[$row][$col])
                {$_ = join '' => @pad[0 .. $pos-1], $_, @pad[$pos .. $#pad]}
        }
    }
    join '' => map {"@$_\n"} @lines
}

print columns <<'END', $_ for qw(left right center);
Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.
END
