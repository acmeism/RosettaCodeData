function twentyfour()
   print [[
 The 24 Game

 Given any four digits in the range 1 to 9, which may have repetitions,
 Using just the +, -, *, and / operators; and the possible use of
 brackets, (), show how to make an answer of 24.

 An answer of "q" will quit the game.
 An answer of "!" will generate a new set of four digits.

 Note: you cannot form multiple digit numbers from the supplied digits,
 so an answer of 12+12 when given 1, 2, 2, and 1 would not be allowed.

 ]]
   expr = re.compile[[   --matches properly formatted infix expressions and returns all numerals as captures
         expr <- (!.) / (<paren> / <number>) (<ws> <oper> <ws> <expr>)?
         number <- {[0-9]}
         ws <- " "*
         oper <- [-+/*]
         paren <- "(" <ws> <expr> <ws> ")"   ]]
   local val_t = {math.random(9), math.random(9), math.random(9), math.random(9)}
   table.sort(val_t)
   print("the digits are " .. table.concat(val_t, ", "))
   local ex = io.read()
   a, b, c, d, e = expr:match(ex)
   if a and b and c and d and not e then --if there is a fifth numeral the player is cheating
      local digs = {a + 0, b + 0, c + 0, d + 0}
      local flag = false -- (terrorism!)
      table.sort(digs)
      for i = 1, 4 do
	   flag = digs[i] ~= val_t[i] and not print"Wrong digits!" or flag
      end
      if not flag and loadstring("return " .. ex)() == 24 then
         print"You win!"
      else
         print"You lose."
      end
   else print"wat" --expression could not be interpreted as arithmetic
   end
end
twentyfour()
