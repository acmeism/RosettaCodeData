# Project : Sorting algorithms/Bogosort

test = [4, 65, 2, 31, 0, 99, 2, 83, 782, 1]
shuffles = 0
while ! sorted(test)
        shuffles = shuffles + 1
        shuffle(test)
end
see "" + shuffles + " shuffles required to sort " + len(test)  + " items:" + nl
showarray(test)

func shuffle(d)
        for i = len(d) to 2 step -1
             item = random(i) + 1
             if item <= len(d)
                temp = d[i-1]
                d[i-1] = d[item]
                d[item] = temp
             else
                i = i -1
             ok
next

func sorted(d)
        for j = 2 to len(d)
             if d[j] < d[j-1]
                return false
             ok
        next
        return true

func showarray(vect)
        see "["
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n] + ", "
        next
        svect = left(svect, len(svect) - 2)
        see svect
        see "]" + nl
