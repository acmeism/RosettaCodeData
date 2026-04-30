' Gaussian elimination - VBScript
    const n=6
    dim a(6,6),b(6),x(6),ab
    ab=array(   1   ,   0   ,   0   ,   0   ,   0   ,   0   ,  -0.01, _
                1   ,   0.63,   0.39,   0.25,   0.16,   0.10,   0.61, _
                1   ,   1.26,   1.58,   1.98,   2.49,   3.13,   0.91, _
                1   ,   1.88,   3.55,   6.70,  12.62,  23.80,   0.99, _
                1   ,   2.51,   6.32,  15.88,  39.90, 100.28,   0.60, _
                1   ,   3.14,   9.87,  31.01,  97.41, 306.02,   0.02)
    k=-1
    for i=1 to n
        buf=""
        for j=1 to n+1
            k=k+1
            if j<=n then
                a(i,j)=ab(k)
            else
                b(i)=ab(k)
            end if
            buf=buf&right(space(8)&formatnumber(ab(k),2),8)&" "
        next
        wscript.echo buf
    next
    for j=1 to n
        for i=j+1 to n
            w=a(j,j)/a(i,j)
            for k=j+1 to n
                a(i,k)=a(j,k)-w*a(i,k)
            next
            b(i)=b(j)-w*b(i)
        next
    next
    x(n)=b(n)/a(n,n)
    for j=n-1 to 1 step -1
        w=0
        for i=j+1 to n
            w=w+a(j,i)*x(i)
        next
        x(j)=(b(j)-w)/a(j,j)
    next
    wscript.echo "solution"
    buf=""
    for i=1 to n
        buf=buf&right(space(8)&formatnumber(x(i),2),8)&vbcrlf
    next
    wscript.echo buf
