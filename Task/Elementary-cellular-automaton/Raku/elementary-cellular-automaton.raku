class Automaton {
    has $.rule;
    has @.cells;
    has @.code = $!rule.fmt('%08b').flip.comb».Int;

    method gist { "|{ @!cells.map({+$_ ?? '#' !! ' '}).join }|" }

    method succ {
        self.new: :$!rule, :@!code, :cells(
            @!code[
                    4 «*« @!cells.rotate(-1)
                »+« 2 «*« @!cells
                »+«       @!cells.rotate(1)
            ]
        )
    }
}

my @padding = 0 xx 10;

my Automaton $a .= new:
    :rule(30),
    :cells(flat @padding, 1, @padding);

say $a++ for ^10;
