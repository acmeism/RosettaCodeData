# Project : Euler's sum of powers conjecture

max=250
for w = 1 to max
     for x = 1 to w
          for y = 1 to x
               for z = 1 to y
                    sum = pow(w,5) + pow(x,5) + pow(y,5) + pow(z,5)
                    s1  = floor(pow(sum,0.2))
                    if sum = pow(s1,5)
                       see "" + w + "^5 + " + x + "^5 + " + y + "^5 + " + z + "^5 = " + s1 + "^5"
                    ok
               next
          next
     next
next
