proc iml;
start sieve(n);
    a = J(n,1);
    a[1] = 0;
    do i = 1 to n;
        if a[i] then do;
            if i*i>n then return(a);
            a[i*(i:int(n/i))] = 0;
        end;
    end;
finish;

a = loc(sieve(1000))`;
create primes from a;
append from a;
close primes;
quit;
