def q(n):
    if n < 1 or type(n) != int: raise ValueError("n must be an int >= 1")
    try:
        return q.seq[n]
    except IndexError:
        ans = q(n - q(n - 1)) + q(n - q(n - 2))
        q.seq.append(ans)
        return ans
q.seq = [None, 1, 1]

if __name__ == '__main__':
    first10 = [q(i) for i in range(1,11)]
    assert first10 == [1, 1, 2, 3, 3, 4, 5, 5, 6, 6], "Q() value error(s)"
    print("Q(n) for n = [1..10] is:", ', '.join(str(i) for i in first10))
    assert q(1000) == 502, "Q(1000) value error"
    print("Q(1000) =", q(1000))
