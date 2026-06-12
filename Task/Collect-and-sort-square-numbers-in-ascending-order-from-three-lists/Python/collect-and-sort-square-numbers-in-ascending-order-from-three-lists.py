import math

print("working...")
list = [(3,4,34,25,9,12,36,56,36),(2,8,81,169,34,55,76,49,7),(75,121,75,144,35,16,46,35)]
Squares = []

def issquare(x):
	for p in range(x):
		if x == p*p:
			return 1
for n in range(3):
	for m in range(len(list[n])):
		if issquare(list[n][m]):
			Squares.append(list[n][m])

Squares.sort()
print(Squares)
print("done...")
