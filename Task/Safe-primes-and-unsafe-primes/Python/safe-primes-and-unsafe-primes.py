primes =[]
sp =[]
usp=[]
n = 10000000
if 2<n:
    primes.append(2)
for i in range(3,n+1,2):
    for j in primes:
        if(j>i/2) or (j==primes[-1]):
            primes.append(i)
            if((i-1)/2) in primes:
                sp.append(i)
                break
            else:
                usp.append(i)
                break
        if (i%j==0):
            break

print('First 35 safe primes are:\n' , sp[:35])
print('There are '+str(len(sp[:1000000]))+' safe primes below 1,000,000')
print('There are '+str(len(sp))+' safe primes below 10,000,000')
print('First 40 unsafe primes:\n',usp[:40])
print('There are '+str(len(usp[:1000000]))+' unsafe primes below 1,000,000')
print('There are '+str(len(usp))+' safe primes below 10,000,000')
