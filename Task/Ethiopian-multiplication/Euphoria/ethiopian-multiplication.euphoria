function emHalf(integer n)
  return floor(n/2)
end function

function emDouble(integer n)
  return n*2
end function

function emIsEven(integer n)
  return (remainder(n,2) = 0)
end function

function emMultiply(integer a, integer b)
 integer sum
  sum = 0
  while (a) do
    if (not emIsEven(a)) then sum += b end if
    a = emHalf(a)
    b = emDouble(b)
  end while

  return sum
end function

----------------------------------------------------------------
-- runtime

printf(1,"emMultiply(%d,%d) = %d\n",{17,34,emMultiply(17,34)})

printf(1,"\nPress Any Key\n",{})
while (get_key() = -1) do end while
