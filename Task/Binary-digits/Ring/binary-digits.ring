see "Number to convert : "
give a
n = 0
while pow(2,n+1) < a
      n = n + 1
end

for i = n to 0 step -1
    x = pow(2,i)
    if a >= x see 1 a = a - x
    else see 0 ok
next
