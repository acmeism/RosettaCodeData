see "working..." + nl
see "Sum of elements below main diagonal of matrix:" + nl
diag = [[1,3,7,8,10],
        [2,4,16,14,4],
        [3,1,9,18,11],
        [12,14,17,18,20],
        [7,1,3,9,5]]

lenDiag = len(diag)
ind = lenDiag
sumDiag = 0

for n=1 to lenDiag
    for m=1 to lenDiag-ind
        sumDiag += diag[n][m]
    next
    ind--
next

see "" + sumDiag + nl
see "done..." + nl
