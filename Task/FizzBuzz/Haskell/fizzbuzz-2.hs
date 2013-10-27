main = putStr $ concat $ map fizzbuzz [1..100]

fizzbuzz n =
    "\n" ++ if null (fizz++buzz) then show n else fizz++buzz
    where fizz = if mod n 3 == 0 then "Fizz" else ""
          buzz = if mod n 5 == 0 then "Buzz" else ""
