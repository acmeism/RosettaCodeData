print("working...")
print("First 20 Cullen numbers:")

for n in range(1,21):
    num = n*pow(2,n)+1
    print(str(num),end= " ")

print()
print("First 20 Woodall numbers:")

for n in range(1,21):
    num = n*pow(2,n)-1
    print(str(num),end=" ")

print()
print("done...")
