def play($tokens):
  label $out
  | "There are \($tokens) tokens.  Take at most \([$tokens,3]|min) or enter q to quit.",
     ( foreach inputs as $in ( {$tokens};
         if $in == "q" then break $out
         else .in = $in
         | if $in | test("^[0-9]+$") then .in |= tonumber else .in = null end
         | if .in and .in > 0 and .in < 4
           then  (4 - .in) as $ct
           | (if $ct == 1 then "" else "s" end) as $s
           | .emit = "  Computer takes \($ct) token\($s);"
           | .tokens += -4
           else .emit = "Please enter a number from 1 to \([3, .tokens]|min) inclusive."
           end
	 end;
	
     .emit,
	 if .tokens == 0
     then "\nComputer wins!", break $out
     elif .tokens < 0 then "\nCongratulations!", break $out
	 else "\(.tokens) tokens remain. How many tokens will you take?"
     end )) ;

play(12)
