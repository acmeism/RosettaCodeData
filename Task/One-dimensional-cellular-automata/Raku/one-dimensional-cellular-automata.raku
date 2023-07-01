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

#  The rule proposed for this task is rule 0b01101000 = 104

my @padding = 0 xx 5;
my Automaton $a .= new:
    rule  => 104,
    cells => flat @padding, '111011010101'.comb, @padding
;
say $a++ for ^10;


# Rule 104 is not particularly interesting so here is [[wp:Rule 90|Rule 90]],
# which shows a [[wp:Sierpinski Triangle|Sierpinski Triangle]].

say '';
@padding = 0 xx 25;
$a = Automaton.new: :rule(90), :cells(flat @padding, 1, @padding);

say $a++ for ^20;
