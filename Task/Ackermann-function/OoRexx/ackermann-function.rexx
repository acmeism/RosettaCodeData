loop m = 0 to 3
    loop n = 0 to 6
        say "Ackermann("m", "n") =" ackermann(m, n)
    end
end

::routine ackermann
  use strict arg m, n
  -- give us some precision room
  numeric digits 10000
  if m = 0 then return n + 1
  else if n = 0 then return ackermann(m - 1, 1)
  else return ackermann(m - 1, ackermann(m, n - 1))
