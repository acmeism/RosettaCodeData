NN=(1:1:1e6); %Natural numbers between 1 and t
pns=NN(isprime(NN)); %prime numbers
p=fliplr(str2num(fliplr(num2str(pns))));
a=pns(isprime(p)); b=p(isprime(p)); c=a-b;
emirps=NN(a(c~=0));
