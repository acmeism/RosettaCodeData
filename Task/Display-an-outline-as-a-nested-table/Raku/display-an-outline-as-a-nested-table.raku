my $outline = q:to/END/;
    Display an outline as a nested table.
        Parse the outline to a tree,
            measuring the indent of each line,
            translating the indentation to a nested structure,
            and padding the tree to even depth.
        count the leaves descending from each node,
            defining the width of a leaf as 1,
            and the width of a parent node as a sum.
                (The sum of the widths of its children)
                Propagating the sums upward as necessary.
        and write out a table with 'colspan' values
            either as a wiki table,
            or as HTML.
        Optionally add color to the nodes.
    END

# Import outline paragraph into native data structure
sub import (Str $trees, $level = '  ') {
    my $forest;
    my $last = -Inf;

    for $trees.lines -> $branch {
        $branch ~~ / ($($level))* /;
        my $this = +$0;
        $forest ~= do {
            given $this cmp $last {
                when More { "\['{esc $branch.trim}', " }
                when Same { "'{esc $branch.trim}', " }
                when Less { "{']' x $last - $this}, '{esc $branch.trim}', " }
            }
        }
        $last = $this;
    }

    sub esc { $^s.subst( /(<['\\]>)/, -> $/ { "\\$0" }, :g) }

    $forest ~= ']' x 1 + $last;
    use MONKEY-SEE-NO-EVAL;
    $forest.EVAL;
}

my @AoA = import $outline, '    ';
my @layout;

# Collect information about node depth, position and children
{
    my @width = 0;
    my $depth = -1;
    @AoA.&insert;

    multi insert ($item) {
        @width[*-1]++;
        @layout.push: { :depth($depth.clone), :id(@width[*-1].clone), :text($item) };
    }

    multi insert (@array) {
        @width.push: @width[*-1] * 10;
        ++$depth;
        @array.map: &insert;
        --$depth;
        @width.pop;
    }
}

my $max-depth = @layout.max( *.<depth> )<depth>;

# Pad ragged nodes
for (^$max-depth) -> $d {
    my @nodes = @layout.grep( *.<depth> == $d );
    for @nodes.sort( +*.<id> ) -> $n {
        unless @layout.first( *.<id> == $n<id> ~ 1 ) {
            @layout.push: { :depth($n<depth> + 1), :id($n<id> *10 + 1), :text('') };
        }
    }
}

# Calculate spans (child nodes)
for (0..$max-depth).reverse -> $d {
    my @nodes = @layout.grep( *.<depth> == $d );
    for @nodes.sort( +*.<id> ) -> $n {
        my @span = @layout.grep: {.<depth> == $d + 1 && .<id>.starts-with: $n<id> };
        $n<span> = ( sum @span.map( { .<span> // 0} )) || +@span || 1;
    }
}

# Programatically assign colors
for (0..$max-depth) -> $d {
    my @nodes = @layout.grep( *.<depth> == $d );
    my $incr = 1 / (1 + @nodes);
    for @nodes.sort( +*.<id> ) -> $n {
        my $color = $d > 1 ??
        @layout.first( *.<id> eq $n<id>.chop )<color> !!
        "style=\"background: #" ~ hsv2rgb( ++$ * $incr, .1, 1) ~ '" ';
        $n<color> = $n<text> ?? $color !! '';
    }
}

# Generate wikitable
say '{| class="wikitable" style="text-align: center;"' ~ "\n" ~
(join "\n|-\n", (0..$max-depth).map: -> $d {
    my @nodes = @layout.grep( *.<depth> == $d );
    (join "\n", @nodes.sort( +*.<id> ).map( -> $node {
        '| ' ~
        ($node<color> // '' ) ~
        ($node<span> > 1 ?? "colspan=$node<span>" !! '' ) ~
        ' | ' ~ $node<text> }
    ))
}) ~ "\n|}";

say "\n\nSometimes it makes more sense to display an outline as...
well... as an outline, rather than as a table." ~ Q|¯\_(ツ)_/¯| ~ "\n";

{ ## Outline - Ordered List #######
    my @type = <upper-roman upper-latin decimal lower-latin lower-roman>;
    my $depth = 0;

    multi ol ($item) { "\<li>$item\n" }

    multi ol (@array) {
        my $li = $depth ?? "</li>" !! '';
        $depth++;
        my $list = "<ol style=\"list-style: {@type[$depth - 1]};\">\n" ~
        ( @array.map( &ol ).join ) ~ "</ol>$li\n";
        $depth--;
        $list
    }

    say "<div style=\"background: #fee;\">\n" ~ @AoA.&ol ~ "</div>";
}

sub hsv2rgb ( $h, $s, $v ){
    my $c = $v * $s;
    my $x = $c * (1 - abs( (($h*6) % 2) - 1 ) );
    my $m = $v - $c;
    my ($r, $g, $b) = do given $h {
        when   0..^(1/6) { $c, $x, 0 }
        when 1/6..^(1/3) { $x, $c, 0 }
        when 1/3..^(1/2) { 0, $c, $x }
        when 1/2..^(2/3) { 0, $x, $c }
        when 2/3..^(5/6) { $x, 0, $c }
        when 5/6..1      { $c, 0, $x }
    }
    ( $r, $g, $b ).map( ((*+$m) * 255).Int)».base(16).join
}
