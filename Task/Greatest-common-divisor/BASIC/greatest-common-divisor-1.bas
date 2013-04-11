function gcd(a%, b%)
   if a > b then
      factor = a
   else
      factor = b
   end if
   for l = factor to 1 step -1
      if a mod l = 0 and b mod l = 0 then
         gcd = l
      end if
   next l
   gcd = 1
end function
