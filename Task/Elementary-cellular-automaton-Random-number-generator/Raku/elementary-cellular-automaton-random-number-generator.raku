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

my Automaton $a .= new: :rule(30), :cells( flat 1, 0 xx 100 );

say :2[$a++.cells[0] xx 8] xx 10;
