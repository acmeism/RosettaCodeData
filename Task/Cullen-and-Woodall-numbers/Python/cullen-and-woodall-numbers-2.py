def cullen(n): return((n<<n)+1)
	
def woodall(n): return((n<<n)-1)

print("First 20 Cullen numbers:")
for i in range(1,21):
	print(cullen(i),end=" ")
print()
print()
print("First 20 Woodall numbers:")
for i in range(1,21):
	print(woodall(i),end=" ")
print()
