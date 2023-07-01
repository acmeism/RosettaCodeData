load "stdlib.ring"

list1 = [:name = "Rocket Skates", :price = 12.75, :color = "yellow"]
list2 = [:price = 15.25, :color = "red", :year = 1974]

for n = 1 to len(list2)
    flag = 0
    for m = 1 to len(list1)
        if list2[n][1] = list1[m][1]
           flag = 1
           del(list1,m)
           add(list1,[list2[n][1],list2[n][2]])
           exit
        ok
    next
    if flag = 0
       add(list1,[list2[n][1],list2[n][2]])
    ok
next

for n = 1 to len(list1)
    see list1[n][1] + " = " + list1[n][2] + nl
next
