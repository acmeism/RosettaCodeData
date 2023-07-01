sub iterate( byval curr as string, byval start as uinteger,_
             byval stp as uinteger, byval depth as uinteger )
    dim as uinteger i
    for i = start to stp
        if depth = 0 then
            print curr + " " + str(i)
        end if
        iterate( curr+" "+str(i), i+1, stp, depth-1 )
    next i
    return
end sub

dim as uinteger m, n
input "Enter n comb m.  ", n, m
dim as string outstr = ""
iterate outstr, 0, m-1, n-1
