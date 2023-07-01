class Automaton {
    has $.rule;
    has @.cells;
    has @.code = $!rule.fmt('%08b').flip.comb».Int;

    method gist { @!cells.map({+$_ ?? '▲' !! '░'}).join }

    method succ {
        self.new: :$!rule, :@!code, :cells(
            ' ',
            |@!code[
                    4 «*« @!cells.rotate(-1)
                »+« 2 «*« @!cells
                »+«       @!cells.rotate(1)
            ],
            ' '
        )
    }
}

my Automaton $a .= new: :rule(90), :cells(flat '010'.comb);

# display the first 20 rows
say $a++ for ^20;

# then calculate the other infinite number of rows, (may take a while)
$a++ for ^Inf;
