@ n = 1
while ( $n <= 100 )
  if ($n % 15 == 0) then
    echo FizzBuzz
  else if ($n % 5 == 0) then
    echo Buzz
  else if ($n % 3 == 0) then
    echo Fizz
  else
    echo $n
  endif
  @ n += 1
end
