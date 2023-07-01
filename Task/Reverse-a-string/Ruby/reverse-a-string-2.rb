graphemes = 'as⃝df̅'.scan(/\X/)
reversed = graphemes.reverse
graphemes.join #=> "f̅ds⃝a"
