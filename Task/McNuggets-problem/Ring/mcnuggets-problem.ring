Nuggets = list(100)

for six = 0 To 100/6
    for nine =  0 To 100/9
        for twenty = 0 To 100/20
            n = six*6 + nine*9 + twenty*20
            If n <= 100 and not (six = 0 and nine = 0 and twenty = 0)
               Nuggets[n] = true
            ok
        next
    next
next

for n = 100 to 1 step -1
    if Nuggets[n] = false
       ? "Maximum non-McNuggets number is: " + n
       exit
    ok
next
