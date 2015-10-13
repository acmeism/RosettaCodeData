const L = 2*10^4
iclasslabel = ["Deficient", "Perfect", "Abundant"]
iclass = zeros(Int64, 3)
iclass[1] = one(Int64) #by convention 1 is deficient

for n in 2:L
    if isprime(n)
        iclass[1] += 1
    else
        iclass[sign(divisorsum(n)-n)+2] += 1
    end
end

println("Classification of integers from 1 to ", L)
for i in 1:3
    println("   ", iclasslabel[i], ", ", iclass[i])
end
