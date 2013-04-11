function c=num2vec(a)
if a==0
    c=0;
else
for i=1:100
    if floor(a/(10^(i-1)))>0
        n=i;
    end
end
c=zeros(1,n);
b=zeros(1,n);
for i=1:n
    b(i)=a/(10^(i-1));
    b(i)=floor(b(i));
end
for i=1:n-1
    b(i)=b(i)-(b(i+1)*10);
end
for i=1:n
    c(i)=b(n-i+1);
end
end
