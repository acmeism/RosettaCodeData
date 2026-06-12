import math
print("working...")
limit1 = 6000
limit2 = 1000
oldSquare = 0
newSquare = 0

for n in range(limit1):
    newSquare = n*n
    if (newSquare - oldSquare > limit2):
     print("Least number is = ", end = "");
     print(int(math.sqrt(newSquare)))
     break
    oldSquare = n*n

print("done...")
print()
