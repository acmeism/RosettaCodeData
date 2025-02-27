require "math"

function isprime(n)
   for i=2, math.sqrt(n) do
       if math.mod(n, i) == 0 then
	       return false
       end
   end
   return true
end

index = 1

for i=2, 1000 do
    sum = 0
    if isprime(i) then
	   for j=2,i do
          if isprime(j) then
             sum = sum + j
	      end
	   end

	   if isprime(sum) then
	       print(index, i, sum)
	   end
       index = index + 1
	end
end
