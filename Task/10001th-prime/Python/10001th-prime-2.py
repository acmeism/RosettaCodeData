import time; max=10001; n=1; p=1; # PRIME_numb.py russian DANILIN
while n<=max: # 78081 994271 45 seconds
    f=0; j=2; s = int(p**0.5) # rextester.com/AAOHQ6342
    while f < 1:
        if j >= s:
            f=2
        if p % j == 0:
            f=1
        j+=1
    if f != 1:
        n+=1;
        #print(n,p);
    p+=1
print(n-1,p-1)
print(time.perf_counter())
