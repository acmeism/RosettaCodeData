print("working...")
row = 0
limit = 1500
Sophie = []

def isPrime(n):
    for i in range(2,int(n**0.5)+1):
        if n%i==0:
            return False
    return True

for n in range(2,limit):
	p = 2*n + 1
	if isPrime(n) and isPrime(p):
		Sophie.append(n)

print("Found ",end = "")
print(len(Sophie),end = "")
print(" Safe and Sophie primes.")

print(Sophie)
print("done...")
