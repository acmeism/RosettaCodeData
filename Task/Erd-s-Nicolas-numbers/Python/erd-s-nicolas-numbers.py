# erdos-nicolas.py by Xing216
from time import perf_counter
start = perf_counter()
def get_div_cnt(n: int) -> None:
    divcnt,divsum = 1,1
    lmt = n/2
    f = 2
    while True:
        if f > lmt: break
        if not (n % f):
            divsum += f
            divcnt += 1
        if divsum == n: break
        f+=1
    print(f"{n:>8} equals the sum of its first {divcnt} divisors")
max_number = 91963649
dsum = [1 for _ in range(max_number+1)]
for i in range(2, max_number + 1):
    for j in range(i + i, max_number + 1, i):
        if (dsum[j] == j): get_div_cnt(j)
        dsum[j] += i
done = perf_counter() - start
print(f"Done in: {done:.3f}s")
