class Automata {
    has ($.rule, @.cells);
    method gist { <| |>.join: @!cells.map({$_ ?? '#' !! ' '}).join }
    method code { $.rule.fmt("%08b").comb.reverse }
    method succ {
	self.new: :$.rule, :cells(
	    self.code[
                [Z+] 4 «*« @.cells.rotate(-1),
                     2 «*« @.cells,
                           @.cells.rotate(1)
	    ]
	)
    }
}
