label $top
| primes
| if (7700 <= .) and (. <= 8000) and is_emirp then .
   elif . > 8000 then break $top
   else empty
   end
