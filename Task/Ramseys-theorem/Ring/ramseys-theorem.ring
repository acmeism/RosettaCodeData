# Project : Ramsey's theorem

load "stdlib.ring"

a = newlist(17,17)
for i = 1 to 17
    a[i][i] = -1
next
k = 1
while k <= 8
      for i = 1 to 17
          j = (i + k) % 17
          if j != 0
             a[i][j] = 1
             a[j][i] = 1
          ok
      next
      k = k * 2
end
for i = 1 to 17
    for j = 1 to 17
        see a[i][j] + " "
    next
    see nl
next
