import Combinatorics: combinations
import Primes: isprime

function primegroups(words, siz)
    results = ""
    for word in words
        found = "Not found"
        for combo in unique!(collect(combinations(word, siz)))
            if all(isprime(abs(Int32(combo[i]) - Int32(combo[j]))) for i in 1:siz, j in 1:siz if i < j)
                found = join(combo)
                break
            end
        end
        results *= found * "\n"
    end
    return results
end

const words = ["riOtjuoq", "wjtiOxtj", "akwercjoeiJ", "Weej", "Aek", "jjgja"]

println("Three character prime groups:")
println(primegroups(words, 3))

println("Two character prime groups:")
println(primegroups(words, 2))
