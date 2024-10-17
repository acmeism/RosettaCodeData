const SPHENIC_NUMBERS = Set{Int64}()
const NOT_SPHENIC_NUMBERS = Set{Int64}()
function issphenic(n::Int64)
    n in SPHENIC_NUMBERS && return true
    n in NOT_SPHENIC_NUMBERS && return false

    nin = n
    sqn = isqrt(nin)

    npfactors = 0
    isrepeat = false

    i = 2
    while n > 1 && !(npfactors == 0 && i >= sqn)
        if n % i == 0
            npfactors += 1

            if isrepeat || npfactors > 3
                push!(NOT_SPHENIC_NUMBERS, nin)
                return false
            end

            isrepeat = true
            n ÷= i
            continue
        end

        i += 1
        isrepeat = false
    end

    if npfactors < 3
        push!(NOT_SPHENIC_NUMBERS, nin)
        return false
    end

    push!(SPHENIC_NUMBERS, nin)
    return true
end

issphenictriple(n::Integer) = issphenic(n) && issphenic(n+1) && issphenic(n+2)
printlntriple(n::Integer) = println("($(n), $(n+1), $(n+2))")

shenums = filter(issphenic, 2:1_000_000)
shetrip = filter(issphenictriple, 2:1_000_000)

# 1. All sphenic numbers less than 1,000.
println("Sphenic numbers less than 1,000:")
less1000 = filter(<(1000), shenums)
foreach(println, Iterators.partition(less1000, 15))

# 2. All sphenic triplets less than 10,000.
println("Sphenic triplets less than 10,000:")
less10000 = filter(<(10_000 - 6), shetrip)
foreach(printlntriple, less10000)

# 3. How many sphenic numbers are there less than 1 million?
println("Number of sphenic numbers that are less than 1 million: ", length(shenums))

# 4. How many sphenic triplets are there less than 1 million?
println("Number of sphenic triplets that are less than 1 million: ", length(shetrip))

# 5. What is the 200,000th sphenic number and its 3 prime factors?
println("The 200,000th sphenic number is: ", shenums[200_000])

# 6. What is the 5,000th sphenic triplet?
print("The 5,000h sphenic triplet is: ")
printlntriple(shetrip[5_000])
