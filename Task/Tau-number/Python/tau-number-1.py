def tau(n):
    assert(isinstance(n, int) and 0 < n)
    ans, i, j = 0, 1, 1
    while i*i <= n:
        if 0 == n%i:
            ans += 1
            j = n//i
            if j != i:
                ans += 1
        i += 1
    return ans

def is_tau_number(n):
    assert(isinstance(n, int))
    if n <= 0:
        return False
    return 0 == n%tau(n)

if __name__ == "__main__":
    n = 1
    ans = []
    while len(ans) < 100:
        if is_tau_number(n):
            ans.append(n)
        n += 1
    print(ans)
