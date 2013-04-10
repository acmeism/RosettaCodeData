a=zeros(1,100);
for b=1:100;
for i=b:b:100;
    if a(i)==1
        a(i)=0;
    else
        a(i)=1;
    end
end
end
a
