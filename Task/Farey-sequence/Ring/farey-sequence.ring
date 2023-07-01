# Project : Farey sequence

for i = 1 to 11
     count = 0
     see "F" + string(i) + " = "
     farey(i, false)
next
see nl
for x = 100 to 1000 step 100
      count = 0
      see "F" + string(x) + " = "
      see farey(x, false)
      see nl
next

func farey(n, descending)
        a = 0
        b = 1
        c = 1
        d = n
        if descending = true
           a = 1
           c = n -1
        ok
        count = count + 1
        if n < 12
           see string(a) + "/" + string(b) + " "
        ok
        while ((c <= n) and not descending) or ((a > 0) and descending)
                  aa = a
                  bb = b
                  cc = c
                  dd = d
                  k = floor((n + b) / d)
                  a = cc
                  b = dd
                  c = k * cc - aa
                  d = k * dd - bb
                  count = count + 1
                  if n < 12
                     see string(a) + "/" + string(b) + " "
                  ok
        end
        if n < 12
           see nl
        ok
        return count
