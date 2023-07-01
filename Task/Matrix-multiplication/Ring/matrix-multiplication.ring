load "stdlib.ring"
n = 3
C = newlist(n,n)
A = [[1,2,3], [4,5,6], [7,8,9]]
B = [[1,0,0], [0,1,0], [0,0,1]]
for i = 1 to n
    for j = 1 to n
       for k = 1 to n
           C[i][k] += A[i][j] * B[j][k]
       next
    next
next
for i = 1 to n
    for j = 1 to n
        see C[i][j] + " "
    next
    see nl
next
