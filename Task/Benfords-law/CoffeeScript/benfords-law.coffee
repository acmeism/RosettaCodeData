fibgen = () ->
    a = 1; b = 0
    return () ->
        ([a, b] = [b, a+b])[1]

leading = (x) -> x.toString().charCodeAt(0) - 0x30

f = fibgen()

benford = (0 for i in [1..9])
benford[leading(f()) - 1] += 1 for i in [1..1000]

log10 = (x) -> Math.log(x) * Math.LOG10E

actual = benford.map (x) -> x * 0.001
expected = (log10(1 + 1/x) for x in [1..9])

console.log "Leading digital distribution of the first 1,000 Fibonacci numbers"
console.log "Digit\tActual\tExpected"
for i in [1..9]
    console.log i + "\t" + actual[i - 1].toFixed(3) + '\t' + expected[i - 1].toFixed(3)
