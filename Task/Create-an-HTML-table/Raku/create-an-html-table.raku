my @header =  <&nbsp; X Y Z>;
my $rows = 5;

sub tag ($tag, $string, $param?) { return "<$tag" ~ ($param ?? " $param" !! '') ~ ">$string" ~ "</$tag>" };

my $table = tag('tr', ( tag('th', $_) for @header));

for 1 .. $rows -> $row {
    $table ~=  tag('tr', ( tag('td', $row, 'align="right"')
    ~ (tag('td', (^10000).pick, 'align="right"') for 1..^@header)));
}

say tag('table', $table, 'cellspacing=4 style="text-align:right; border: 1px solid;"');
