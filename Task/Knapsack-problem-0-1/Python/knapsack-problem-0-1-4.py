n=5; N=n+1; G=5; a=2**N	# KNAPSACK 0-1 DANILIN 	
L=[];C=[];e=[];j=[];q=[];s=[] # rextester.com/BCKP19591
d=[];L=[1]*n;C=[1]*n;e=[1]*a	
j=[1]*n;q=[0]*a;s=[0]*a;d=[0]*a

from random import randint
for i in range(0,n):
    L[i]=randint(1,3)
    C[i]=10+randint(1,9)
    print(i+1,L[i],C[i])
print()

for h in range(a-1,(a-1)//2,-1):
    b=str(bin(h))
    e[h]=b[3:len(b)]

    for k in range (n):
        j[k]=int(e[h][k])
        q[h]=q[h]+L[k]*j[k]*C[k]
        d[h]=d[h]+L[k]*j[k]

    if d[h]<= G:
        print(e[h], G, d[h], q[h])
print()

max=0; m=1
for i in range(a):
    if d[i]<=G and q[i]>max:
        max=q[i]; m=i	
print (d[m], q[m], e[m])
