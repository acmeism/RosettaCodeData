using Primes

ispanbasecomposite(n) = (d = digits(n); all(b -> !isprime(evalpoly(b, d)), maximum(d)+1:max(10, n)))

panbase2500 = filter(ispanbasecomposite, 2:2500)
oddpanbase2500 = filter(isodd, panbase2500)
ratio = length(oddpanbase2500) // length(panbase2500)

println("First 50 pan base non-primes:")
foreach(p -> print(lpad(p[2], 4), p[1] % 10 == 0 ? "\n" : ""), pairs(panbase2500[1:50]))

println("\nFirst 20 odd pan base non-primes:")
foreach(p -> print(lpad(p[2], 4), p[1] % 10 == 0 ? "\n" : ""), pairs(oddpanbase2500[1:20]))

println("\nCount of pan-base composites up to and including 2500: ", length(panbase2500))

println("Odd up to and including 2500: ", ratio, ", or ", Float16(ratio * 100), "%.")
println("Even up to and including 2500: ", 1 - ratio, ", or ", Float16((1.0 - ratio) * 100), "%.")
