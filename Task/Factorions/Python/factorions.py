fact = [1] # cache factorials from 0 to 11
for n in range(1, 12):
    fact.append(fact[n-1] * n)

for b in range(9, 12+1):
    print(f"The factorions for base {b} are:")
    for i in range(1, 1500000):
        fact_sum = 0
        j = i
        while j > 0:
            d = j % b
            fact_sum += fact[d]
            j = j//b
        if fact_sum == i:
            print(i, end=" ")
    print("\n")
