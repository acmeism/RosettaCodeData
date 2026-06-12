function sort(s as string) as string
    'quick and dirty bubblesort, not the focus of this exercise
    dim as string t = s
    dim as uinteger i, j, n = len(t)
    dim as boolean sw

    for i = n to 2 step -1
        sw = false
        for j = 1 to i-1
             if asc(mid(t,j,1))>asc(mid(t,j+1,1)) then
                 sw = true
                 swap t[j-1], t[j]
             end if
        next j
        if sw = false then return t

    next i
    return t
end function

dim as string ns(1 to 6)
dim as uinteger n = 0, i
do
    n+=1
    for i = 1 to 6
        ns(i) = sort(str(i*n))
        if i>1 andalso ns(i)<>ns(i-1) then continue do
    next i
    print n, 2*n, 3*n, 4*n, 5*n, 6*n
    end
loop
