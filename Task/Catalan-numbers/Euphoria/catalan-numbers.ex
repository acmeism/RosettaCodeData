--Catalan number task from Rosetta Code wiki
--User:Lnettnay

--function from factorial task
function factorial(integer n)
atom f = 1
while n > 1 do
        f *= n
        n -= 1
end while

return f
end function

function catalan(integer n)
atom numerator = factorial(2 * n)
atom denominator = factorial(n+1)*factorial(n)
return numerator/denominator
end function

for i = 0 to 15 do
        ? catalan(i)
end for
