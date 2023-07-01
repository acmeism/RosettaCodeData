#include once "matmult.bas"
#include once "rowech.bas"

function matinv( A as Matrix ) as Matrix
    dim ret as Matrix, working as Matrix
    dim as uinteger i, j
    if not ubound( A.m, 1 ) = ubound( A.m, 2 ) then return ret
    dim as integer n = ubound(A.m, 1)
    redim ret.m( n, n )
    working = Matrix( n+1, 2*(n+1) )
    for i = 0 to n
        for j = 0 to n
            working.m(i, j) = A.m(i, j)
        next j
        working.m(i, i+n+1) = 1
    next i
    working = rowech(working)
    for i = 0 to n
        for j = 0 to n
            ret.m(i, j) = working.m(i, j+n+1)
        next j
    next i
    return ret
end function

dim as integer i, j
dim as Matrix M = Matrix(3,3)
for i = 0 to 2
    for j = 0 to 2
        M.m(i, j) = 1 + i*i + 3*j + (i+j) mod 2   'just some arbitrary values
        print M.m(i, j),
    next j
    print
next i
print
M = matinv(M)
for i = 0 to 2
    for j = 0 to 2
        print M.m(i, j),
    next j
    print
next i
