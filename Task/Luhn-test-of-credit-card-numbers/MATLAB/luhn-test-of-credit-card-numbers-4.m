function T=luhn(a)
a=num2vec(a);
N=length(a);
for i=1:N
    b(i)=a(N+1-i);
end
for i=1:ceil(N/2)
    c(i+1)=b(2*i-1);
end
s1=sum(c);
for i=1:floor(N/2)
    d(i)=sum(num2vec(2*b(2*i)));
end
s2=sum(d);
T=s1+s2;
