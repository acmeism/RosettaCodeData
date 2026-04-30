function amicable
    tic
    N=2:1:20000; aN=[];
    N(isprime(N))=[]; %erase prime numbers
    I=1;
    a=N(1); b=sum(pd(a));
    while length(N)>1
        if a==b %erase perfect numbers;
            N(N==a)=[]; a=N(1); b=sum(pd(a));
        elseif b<a %the first member of an amicable pair is abundant not defective
            N(N==a)=[]; a=N(1); b=sum(pd(a));
        elseif ~ismember(b,N) %the other member was previously erased
            N(N==a)=[]; a=N(1); b=sum(pd(a));
        else
            c=sum(pd(b));
            if a==c
                aN(I,:)=[I a b]; I=I+1;
                N(N==b)=[];
            else
                if ~ismember(c,N) %the other member was previously erased
                    N(N==b)=[];
                end
            end
            N(N==a)=[]; a=N(1); b=sum(pd(a));
            clear c
        end
    end
    disp(array2table(aN,'Variablenames',{'N','Amicable1','Amicable2'}))
    toc
end

function D=pd(x)
    K=1:ceil(x/2);
    D=K(~(rem(x, K)));
end
