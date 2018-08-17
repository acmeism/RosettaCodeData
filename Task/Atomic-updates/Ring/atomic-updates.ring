# Project : Atomic updates

bucket = list(10)
f2 = 0
for i = 1 to 10
     bucket[i] = floor(random(9)*10)
next

a = display("display:")
see nl	
a = flatten(a)	
see "" + a + nl
a = display("flatten:")	
see nl
a = transfer(3,5)	
see a + nl
see "19 from 3 to 5: "	
a = display(a)
see nl

func display(a)
        display = 0
        see "" + a + " " + char(9)
        for i = 1 to 10
             display = display + bucket[i]
             see "" + bucket[i] + " "
        next
       see " total:" + display
       return display

func flatten(f)
        f1 = floor((f / 10) + 0.5)
        for i = 1 to 10
             bucket[i] = f1
             f2	 = f2 + f1
        next
        bucket[10] = bucket[10] + f - f2

func transfer(a1,a2)
        transfer = floor(random(9)/10 * bucket[a1])
        bucket[a1] = bucket[a1] - transfer
        bucket[a2] = bucket[a2] + transfer
