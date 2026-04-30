' Partition an integer X into N primes
    dim p(),a(32),b(32),v,g: redim p(64)
    what="99809 1  18 2  19 3  20 4  2017 24  22699 1-4  40355 3"
    t1=split(what,"  ")
    for j=0 to ubound(t1)
        t2=split(t1(j)): x=t2(0): n=t2(1)
        t3=split(x,"-"): x=clng(t3(0))
        if ubound(t3)=1 then y=clng(t3(1)) else y=x
        t3=split(n,"-"): n=clng(t3(0))
        if ubound(t3)=1 then m=clng(t3(1)) else m=n
        genp y 'generate primes in p
        for g=x to y
            for q=n to m: part: next 'q
        next 'g
    next 'j

sub genp(high)
    p(1)=2: p(2)=3: c=2: i=p(c)+2
    do 'i
        k=2: bk=false
        do while k*k<=i and not bk 'k
            if i mod p(k)=0 then bk=true
            k=k+1
        loop 'k
        if not bk then
            c=c+1: if c>ubound(p) then redim preserve p(ubound(p)+8)
            p(c)=i
        end if
        i=i+2
    loop until p(c)>high 'i
end sub 'genp

sub getp(z)
    if a(z)=0 then w=z-1: a(z)=a(w)
    a(z)=a(z)+1: w=a(z): b(z)=p(w)
end sub 'getp

function list()
    w=b(1)
    if v=g then for i=2 to q: w=w&"+"&b(i): next else w="(not possible)"
    list="primes: "&w
end function 'list

sub part()
    for i=lbound(a) to ubound(a): a(i)=0: next 'i
    for i=1 to q: call getp(i): next 'i
    do while true: v=0: bu=false
        for s=1 to q
            v=v+b(s)
            if v>g then
                if s=1 then exit do
                for k=s to q: a(k)=0: next 'k
                for r=s-1 to q: call getp(r): next 'r
                bu=true: exit for
            end if
        next 's
        if not bu then
            if v=g then exit do
            if v<g then call getp(q)
        end if
    loop
    wscript.echo "partition "&g&" into "&q&" "&list
end sub 'part
