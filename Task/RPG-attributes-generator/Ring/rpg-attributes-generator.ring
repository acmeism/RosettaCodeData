# Project  : RPG Attributes Generator

load "stdlib.ring"
attributestotal = 0
count = 0
while attributestotal < 75 or count < 2
        attributes = []
        for attribute = 0 to 6
             rolls = []
             largest3 = []
             for roll = 0 to 4
                  result = random(5)+1
                  add(rolls,result)
             next
             sortedrolls = sort(rolls)
             sortedrolls = reverse(sortedrolls)
             for n = 1 to 3
                  add(largest3,sortedrolls[n])
             next
             rollstotal = sum(largest3)
             if rollstotal >= 15
                count = count + 1
             ok
             add(attributes,rollstotal)
        next
        attributestotal = sum(attributes)
end
showline()

func sum(aList)
       num = 0
       for n = 1 to len(aList)
            num = num + aList[n]
       next
       return num

func showline()
        line = "(" + attributestotal + ", ["
        for n = 1 to len(attributes)
             line = line + attributes[n] + ", "
        next
        line = left(line,len(line)-2)
        line = line + "])"
        see line + nl
