def Riordan(N):
    a = [1, 0, 1]
    for n in range(3, N):
        a.append((n - 1) * (2 * a[n - 1] + 3 * a[n - 2]) // (n + 1))
    return a

rios = Riordan(10_000)

for i in range(32):
    print(f'{rios[i] : 18,}', end='\n' if (i + 1) % 4 == 0 else '')

print(f'The 1,000th Riordan has {len(str(rios[999]))} digits.')
print(f'The 10,000th Rirdan has {len(str(rios[9999]))} digits.')
