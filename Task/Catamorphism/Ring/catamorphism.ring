n = list(10)
for i = 1 to 10
    n[i] = i
next

see "  +: " + cat(10,"+") + nl+
    "  -: " + cat(10,"-") + nl +
    "  *: " + cat(10,"*") + nl +
    "  /: " + cat(10,"/") + nl+
    "  ^: " + cat(10,"^") + nl +
    "min: " + cat(10,"min") + nl+
    "max: " + cat(10,"max") + nl+
    "avg: " + cat(10,"avg") + nl +
    "cat: " + cat(10,"cat") + nl

func cat count,op
     cat = n[1]
     cat2 = ""
     for i = 2 to count
         switch op
                on "+" cat +=  n[i]
                on "-"  cat -=  n[i]
                on "*" cat *=  n[i]
                on "/" cat /=  n[i]
                on "^" cat ^=  n[i]
                on "max" cat = max(cat,n[i])
                on "min" cat = min(cat,n[i])
                on "avg" cat +=  n[i]
                on "cat" cat2 += string(n[i])
          off
     next
if op = "avg"  cat = cat / count ok
if op = "cat"  decimals(0) cat = string(n[1])+cat2 ok
return cat
