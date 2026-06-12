function ispal( byval n as integer, b as integer ) as boolean
    'determines if n is palindromic in base b
    dim as string ns
    while n
        ns += chr(48+n mod b)       'temporarily represent as a string
        n\=b
    wend
    for i as integer = 1 to len(ns)\2
        if mid(ns,i,1)<>mid(ns,len(ns)-i+1,1) then return false
    next i
    return true
end function

for i as integer = 0 to 25000
    if ispal(i,16) andalso ispal(i,4) andalso ispal(i,2) then print i;"  ";
next i
