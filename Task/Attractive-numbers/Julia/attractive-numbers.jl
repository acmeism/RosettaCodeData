using Primes

# oneliner is println("The attractive numbers from 1 to 120 are:\n", filter(x -> isprime(sum(values(factor(x)))), 1:120))

isattractive(n) = isprime(sum(values(factor(n))))

printattractive(m, n) = println("The attractive numbers from $m to $n are:\n", filter(isattractive, m:n))

printattractive(1, 120)
