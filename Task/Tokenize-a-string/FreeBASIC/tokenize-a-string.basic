sub tokenize( instring as string, tokens() as string, sep as string )
    redim tokens(0 to 0) as string
    dim as string*1 ch
    dim as uinteger t=0
    for i as uinteger = 1 to len(instring)
        ch = mid(instring,i,1)
        if ch = sep then
            t = t + 1
            redim preserve tokens(0 to t)
        else
            tokens(t) = tokens(t) + ch
        end if
    next i
    return
end sub

dim as string instring = "Hello,How,Are,You,Today"
redim as string tokens(-1)
tokenize( instring, tokens(), "," )
for i as uinteger = 0 to ubound(tokens)
   print tokens(i);".";
next i
