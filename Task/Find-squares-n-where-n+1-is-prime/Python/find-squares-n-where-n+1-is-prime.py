limit = 1000
print("working...")

def isprime(n):
    for i in range(2,int(n**0.5)+1):
        if n%i==0:
            return False
    return True

def issquare(x):
	for n in range(1,x+1):
		if (x == n*n):
			return 1
	return 0

for n in range(limit-1):
	if issquare(n) and isprime(n+1):
		print(n,end=" ")

print()
print("done...")
