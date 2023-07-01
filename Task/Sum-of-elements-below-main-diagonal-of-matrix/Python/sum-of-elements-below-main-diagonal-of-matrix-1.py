from numpy import array, tril, sum

A = [[1,3,7,8,10],
    [2,4,16,14,4],
    [3,1,9,18,11],
    [12,14,17,18,20],
    [7,1,3,9,5]]

print(sum(tril(A, -1)))   # 69
