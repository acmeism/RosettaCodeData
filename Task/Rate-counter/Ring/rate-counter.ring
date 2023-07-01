# Project : Rate counter

see "method 1: calculate reciprocal of elapsed time:" + nl
for trial = 1 to 3
    start = clock()
    tasktomeasure()
    finish = clock()
    see "rate = " + 100 / (finish-start) + " per second" + nl
next

see "method 2: count completed tasks in one second:" + nl
for trial = 1 to 3
    runs = 0
    finish = clock() + 100
    while clock()  < finish
          tasktomeasure()
          if clock() < finish
             runs = runs + 1
          ok
    end
    see "rate = " + runs + " per second" + nl
next

func tasktomeasure
     for i = 1 to 100000
     next
