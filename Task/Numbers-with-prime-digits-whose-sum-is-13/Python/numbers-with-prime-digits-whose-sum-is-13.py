from collections import deque

def prime_digits_sum(r):
    q = deque([(r, 0)])
    while q:
        r, n = q.popleft()
        for d in 2, 3, 5, 7:
            if d >= r:
                if d == r: yield n + d
                break
            q.append((r - d, (n + d) * 10))

print(*prime_digits_sum(13))
