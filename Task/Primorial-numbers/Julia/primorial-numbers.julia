using Primes

primelist = primes(300000001) # primes to 30 million

primorial(n) = foldr(*, primelist[1:n], init=BigInt(1))

println("The first ten primorials are: $([primorial(n) for n in 1:10])")

for i in 1:6
    n = 10^i
    p = primorial(n)
    plen = Int(floor(log10(p))) + 1
    println("primorial($n) has length $plen digits in base 10.")
end
