using Primes

function homeprimechain(n::BigInt)
    isprime(n) && return [n]
    concat = prod(string(i)^j for (i, j) in factor(n).pe)
    return pushfirst!(homeprimechain(parse(BigInt, concat)), n)
end
homeprimechain(n::Integer) = homeprimechain(BigInt(n))

function printHPiter(n, numperline = 4)
    chain = homeprimechain(n)
    len = length(chain)
    for (i, ent) in enumerate(chain)
        print(i < len ? "HP$ent" * "($(len - i)) = " * (i % numperline == 0 ? "\n" : "") : "$ent is prime.\n\n")
    end
end

for i in [2:20; 65]
   print("Home Prime chain for $i: ")
   printHPiter(i)
end
