load "stdlib.ring"
transpose = newlist(5,4)
matrix = [[78,19,30,12,36], [49,10,65,42,50], [30,93,24,78,10], [39,68,27,64,29]]
for i = 1 to 5
    for j = 1 to 4
        transpose[i][j] = matrix[j][i]
        see "" + transpose[i][j] + " "
    next
    see nl
next
