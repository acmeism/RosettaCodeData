def sum_of_divisors(n):
    assert(isinstance(n, int) and 0 < n)
    ans, i, j = 0, 1, 1
    while i*i <= n:
        if 0 == n%i:
            ans += i
            j = n//i
            if j != i:
                ans += j
        i += 1
    return ans

if __name__ == "__main__":
    print([sum_of_divisors(n) for n in range(1,101)])
