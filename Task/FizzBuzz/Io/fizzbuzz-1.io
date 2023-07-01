for(a,1,100,
   if(a % 15 == 0) then(
      "FizzBuzz" println
   ) elseif(a % 3 == 0) then(
      "Fizz" println
   ) elseif(a % 5 == 0) then(
      "Buzz" println
   ) else (
      a println
   )
)
