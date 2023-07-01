load "stdlib.ring"

see "working..." + nl
see "The first 50 self numbers are:" + nl

n = 0
num = 0
limit = 51
limit2 = 10000000

while true
    n = n + 1
    for m = 1 to n
        flag = 1
        sum = 0
        strnum = string(m)
        for p = 1 to len(strnum)
            sum = sum + number(strnum[p])
        next
        sum2 = m + sum
        if sum2 = n
           flag = 0
           exit
        else
           flag = 1
        ok
     next
     if flag = 1
        num = num + 1
        if num < limit
           see "" + num + ". " + n + nl
        ok
        if num = limit2
           see "The " + limit2 + "th self number is: " + n + nl
        ok
        if num > limit2
           exit
        ok
     ok
end

see "done..." + nl
