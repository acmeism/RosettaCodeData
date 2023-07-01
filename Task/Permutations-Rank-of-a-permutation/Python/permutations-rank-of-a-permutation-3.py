def ranker1(n, pi, pi1):
    if n == 1:
        return 0
    n1 = n-1
    s = pi[n1]
    pi[n1], pi[pi1[n1]] = pi[pi1[n1]], pi[n1]
    pi1[s], pi1[n1] = pi1[n1], pi1[s]
    return s + n * ranker1(n1, pi, pi1)

def ranker2(n, pi, pi1):
    result = 0
    for i in range(n-1, 0, -1):
        s = pi[i]
        pi[i], pi[pi1[i]] = pi[pi1[i]], pi[i]
        pi1[s], pi1[i] = pi1[i], pi1[s]
        result += s * fact(i)
    return result
