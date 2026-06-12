#define min(a, b) Iif(a<=b,a,b)

sub minab( n as uinteger )
    for i as uinteger = 1 to n
        for j as uinteger = 1 to n
            print using "## ";min( min(i-1, n-i), min(j-1, n-j) );
        next j
        print
    next i
end sub

minab(10)
