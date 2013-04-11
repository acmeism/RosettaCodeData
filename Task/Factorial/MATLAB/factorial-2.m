function f=fac(n)
    if n==0
        f=1;
        return
    else
        f=n*fac(n-1);
    end
