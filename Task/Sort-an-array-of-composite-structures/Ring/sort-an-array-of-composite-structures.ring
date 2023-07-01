aList= sort([:Eight = 8, :Two = 2, :Five = 5, :Nine = 9, :One = 1,
             :Three = 3, :Six = 6, :Seven = 7, :Four = 4, :Ten = 10] , 2)
for item in aList
    ? item[1] + space(10-len(item[1])) + item[2]
next
