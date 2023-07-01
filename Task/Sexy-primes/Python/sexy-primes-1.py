LIMIT = 1_000_035
def primes2(limit=LIMIT):
    if limit < 2: return []
    if limit < 3: return [2]
    lmtbf = (limit - 3) // 2
    buf = [True] * (lmtbf + 1)
    for i in range((int(limit ** 0.5) - 3) // 2 + 1):
        if buf[i]:
            p = i + i + 3
            s = p * (i + 1) + i
            buf[s::p] = [False] * ((lmtbf - s) // p + 1)
    return [2] + [i + i + 3 for i, v in enumerate(buf) if v]

primes = primes2(LIMIT +6)
primeset = set(primes)
primearray = [n in primeset for n in range(LIMIT)]

#%%
s = [[] for x in range(4)]
unsexy = []

for p in primes:
    if p > LIMIT:
        break
    if p + 6 in primeset and p + 6 < LIMIT:
        s[0].append((p, p+6))
    elif p + 6 in primeset:
        break
    else:
        if p - 6 not in primeset:
            unsexy.append(p)
        continue
    if p + 12 in primeset and p + 12 < LIMIT:
        s[1].append((p, p+6, p+12))
    else:
        continue
    if p + 18 in primeset and p + 18 < LIMIT:
        s[2].append((p, p+6, p+12, p+18))
    else:
        continue
    if p + 24 in primeset and p + 24 < LIMIT:
        s[3].append((p, p+6, p+12, p+18, p+24))

#%%
print('"SEXY" PRIME GROUPINGS:')
for sexy, name in zip(s, 'pairs triplets quadruplets quintuplets'.split()):
    print(f'  {len(sexy)} {na (not isPrime(n-6))))) |> Array.ofSeq
printfn "There are %d unsexy primes less than 1,000,035. The last 10 are:" n.Length
Array.skip (n.Length-10) n |> Array.iter(fun n->printf "%d " n); printfn ""
let ni=pCache |> Seq.takeWhile(fun n->nme} ending with ...')
    for sx in sexy[-5:]:
        print('   ',sx)

print(f'\nThere are {len(unsexy)} unsexy primes ending with ...')
for usx in unsexy[-10:]:
    print(' ',usx)
