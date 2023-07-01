import std

// combi is an itertor that solves the Combinations problem for iota arrays as stated

def combi(m, n, f):
    let c = map(n): _

    while true:
        f(c)
        var i = n-1
        c[i] = c[i] + 1
        if c[i] > m - 1:
            while c[i] >= m - n + i:
                i -= 1
                if i < 0: return
            c[i] = c[i] + 1
            while i < n-1:
                c[i+1] = c[i] + 1
                i += 1

combi(5, 3): print(_)
