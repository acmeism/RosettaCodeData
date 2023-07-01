beginTime = TimeList()[13]
for n = 1 to 10000000
    n = n + 1
next
endTime = TimeList()[13]
elapsedTime = endTime - beginTime
see "Elapsed time = " + elapsedTime + nl
