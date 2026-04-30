declare integer i%

for i% = 1 to 100
  if i% mod 15 = 0 then
    print 'FizzBuzz'
  elseif i% mod 3 = 0 then
    print 'Fizz'
  elseif i% mod 5 = 0 then
    print 'Buzz'
  else
    print i%
  end if
next i%
