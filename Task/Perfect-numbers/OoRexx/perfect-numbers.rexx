-- first perfect number over 10000 is 33550336...let's not be crazy
loop i = 1 to 10000
    if perfectNumber(i) then say i "is a perfect number"
end

::routine perfectNumber
  use strict arg n

  sum = 0

  -- the largest possible factor is n % 2, so no point in
  -- going higher than that
  loop i = 1 to n % 2
      if n // i == 0 then sum += i
  end

  return sum = n
