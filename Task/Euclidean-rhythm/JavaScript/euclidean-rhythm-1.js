const E = (k, n) => {
    let s = Array(n).fill(0)
        .map((_, i) => (i < k ? [1] : [0]))

    let d = n - k
    n = Math.max(k, d)
    k = Math.min(k, d)
    let z = d

    while (z > 0 || k > 1) {
        for (let i = 0; i < k; i++)
            s[i].push(...s[s.length - 1 - i])
        s.splice(-k)
        z = z - k
        d = n - k
        n = Math.max(k, d)
        k = Math.min(k, d)
    }

    return s.flat()
}

