for n = 1 to 9
    see "p(" + n + ") = " + pancake(n) + nl
next
return 0

func pancake(n)
     gap = 2
     sum = 2
     adj = -1;
     while (sum < n)
            adj = adj + 1
            gap = gap * 2 - 1
            sum = sum + gap
     end
     return n + adj
