'`f   b   fb'  =: ('Fizz'"_) ` ('Buzz'"_) ` (f , b)
'`cm3 cm5 cm15'=: (3&|)      ` (5&|)      ` (15&|)  (0&=@)
FizzBuzz=: ": ` f @. cm3 ` b @. cm5 ` fb @. cm15  NB. also:
FizzBuzz=: ": ` f @. cm3 ` b @. cm5 ` (f,b) @. (cm3 *. cm5)

FizzBuzz"0 >: i.100
