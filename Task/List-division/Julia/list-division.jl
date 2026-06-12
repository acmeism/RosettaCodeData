""" Divide a list lis into n (approximately) equal parts. """
function listdiv(lis::Vector{T}, n::Integer) where T
    len = length(lis)
    n < 1 && error("Divisor n must be a positive integer.")
    n > len && error("Divisor n is too large.")
    len < 2 && return [lis] # if the list has 0 or 1 element, return it as the only part
    step, r = divrem(len, n)
    out = Vector{Vector{T}}()
    i = 0
    for part in 1:n
        nextchunksize = part <= r ? step + 1 : step
        push!(out, lis[(i+1):(i+nextchunksize)])
        i += nextchunksize
    end
    return out
end

function testlistdiv()
    println(listdiv([94, 94, 13, 77, 35, 10, 51, 27, 60], 6))
    println(listdiv([19, 46, 43, 17, 94], 1))
    println(listdiv([93, 88, 40, 88, 30, 68, 84, 25], 3))
    println(listdiv([88, 94, 10, 27, 54, 14], 3))
    println(listdiv([31, 19, 63, 57, 57, 74, 50, 14, 38], 4))
    # Expected: [[31, 19, 63], [57, 57], [74, 50], [14, 38]]
    println(listdiv([72, 57, 89, 55, 36, 84, 10, 95, 99, 35], 7))
    # Expected: [[72, 57], [89, 55], [36, 84], [10], [95], [99], [35]]
    println('-' ^ 20)
    for _ in 1:10
        k = rand(0:10)
        lis = rand(10:99, k)
        n = rand(1:10)
        print("listdiv(", lis, ",", n, ") = ")
        try
            print(" ", listdiv(lis, n))
        catch e
            print("Error, cannot divide list $lis by $n: $e")
        end
        print("\n")
    end
end

testlistdiv()
