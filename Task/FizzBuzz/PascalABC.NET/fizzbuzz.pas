begin
  for var i:=1 to 100 do
    if i mod 15 = 0 then
      Print('FizzBuzz')
    else if i mod 3 = 0 then
      Print('Fizz')
    else if i mod 5 = 0 then
      Print('Buzz')
    else Print(i)
end.
