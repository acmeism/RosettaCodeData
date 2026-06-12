print("working...")
limit = 1000000
res1 = 0
res2 = 0
maxOld = 0
newDiff = 0
oldDiff = 0

def isPrime(n):
    for i in range(2,int(n**0.5)+1):
        if n%i==0:
            return False
    return True

for n in range(limit):
    newDiff = n - maxOld
    if isPrime(n):
       if (newDiff > oldDiff):
       	  res1 = n
       	  res2 = maxOld
          oldDiff = newDiff
       maxOld = n

diff = res1 - res2
print(res1)
print(res2)
print("Largest difference is = ",end="")
print(diff)
print("done...")
