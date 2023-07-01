import std

// set S of length n, choose k

def choose(s, k, f):
    let got = map(k): s[0]
    let n = s.length

    def choosi(n_chosen, at):
        var count = 0
        if n_chosen == k:
            f(got)
            return 1
        var i = at
        while i < n:
            got[n_chosen] = s[i]
            count += choosi(n_chosen + 1, i)
            i += 1
        return count
    return choosi(0, 0)

let count = choose(["iced", "jam", "plain"], 2): print(_)
print count
let extra = choose(map(10):_, 3): _
print extra
