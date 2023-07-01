a = [ 1..10 ]
arithmetic_mean = (a) -> a.reduce(((s, x) -> s + x), 0) / a.length
geometic_mean = (a) -> Math.pow(a.reduce(((s, x) -> s * x), 1), (1 / a.length))
harmonic_mean = (a) -> a.length / a.reduce(((s, x) -> s + 1 / x), 0)

A = arithmetic_mean a
G = geometic_mean a
H = harmonic_mean a

console.log "A = ", A, " G = ", G, " H = ", H
console.log "A >= G : ", A >= G, " G >= H : ", G >= H
