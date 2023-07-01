# Project : Shoelace formula for polygonal area

p = [[3,4], [5,11], [12,8], [9,5], [5,6]]
see "The area of the polygon = " + shoelace(p)

func shoelace(p)
        sum = 0
        for i = 1 to len(p) -1
             sum = sum + p[i][1] * p[i +1][2]
             sum = sum - p[i +1][1] * p[i][2]
        next
        sum = sum + p[i][1] * p[1][2]
        sum = sum - p[1][1] * p[i][2]
        return fabs(sum) / 2
