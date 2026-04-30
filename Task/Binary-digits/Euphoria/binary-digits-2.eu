include std/math.e
include std/convert.e

function Bin(integer n, sequence s = "")
  if n > 0 then
   return Bin(floor(n/2),(mod(n,2) + #30) & s)
  end if
  if length(s) = 0 then
   return to_integer("0")
  end if
  return to_integer(s)
end function

printf(1, "%d\n", Bin(5))
printf(1, "%d\n", Bin(50))
printf(1, "%d\n", Bin(9000))
