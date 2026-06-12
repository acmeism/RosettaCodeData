print("working...")
print("Primes are:")

def isprime(m):
    for i in range(2,int(m**0.5)+1):
        if m%i==0:
            return False
    return True

Primes = [2,43,81,122,63,13,7,95,103]
Temp = []

for n in range(len(Primes)):
	if isprime(Primes[n]):
		Temp.append(Primes[n])

Temp.sort()
print(Temp)
print("done...")
