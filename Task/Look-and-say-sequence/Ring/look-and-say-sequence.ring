number = "1"
for nr = 1 to 10
    number = lookSay(number)
    see number + nl
next

func lookSay n
     i = 0 j = 0 c="" o=""
     i = 1
     while i <= len(n)
           c = substr(n,i,1)
           j = i + 1
           while substr(n,j,1) = c
                 j += 1
           end
           o += string(j-i) + c
           i = j
      end
      return o
