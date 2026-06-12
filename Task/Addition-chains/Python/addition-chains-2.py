def bauer(n):
    chain = [0]*n
    in_chain = [False]*(n + 1)
    best = None
    best_len = n
    cnt = 0

    def extend_chain(x=1, pos=0):
        nonlocal best, best_len, cnt

        if x<<(best_len - pos) < n:
            return

        chain[pos] = x
        in_chain[x] = True
        pos += 1

        if in_chain[n - x]:  # found solution
            if pos == best_len:
                cnt += 1
            else:
                best = tuple(chain[:pos])
                best_len, cnt = pos, 1
        elif pos < best_len:
            for i in range(pos - 1, -1, -1):
                c = x + chain[i]
                if c < n:
                    extend_chain(c, pos)

        in_chain[x] = False

    extend_chain()
    return best + (n,), cnt

for n in [7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379]:
    best, cnt = bauer(n)
    print(f'L({n}) = {len(best) - 1}, count of minimum chain: {cnt}\ne.g.: {best}\n')
