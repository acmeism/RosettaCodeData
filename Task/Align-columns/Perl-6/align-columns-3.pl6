sub MAIN ($alignment where 'left'|'right', $file) {
    my @lines := $file.IO.lines.map(*.split: '$').List;
    my @widths = roundrobin(|@lines).map(*».chars.max);
    my $align  = {left=>'-', right=>''}{$alignment};
    my $format = @widths.map({ "%{++$}\${$align}{$_}s" }).join(" ") ~ "\n";
    printf $format, |$_ for @lines;
}
