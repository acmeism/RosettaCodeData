function onlyconsecutivein(a::Vector{T}, lis::Vector{T}) where T
    return any(i -> a == lis[i:i+length(a)-1], 1:length(lis)-length(a)+1) &&
        all(count(x -> x == a[i], lis) == count(x -> x == a[i], a) for i in eachindex(a))
end

needle = [3, 3, 3]
for haystack in [
   [9,3,3,3,2,1,7,8,5],
   [5,2,9,3,3,7,8,4,1],
   [1,4,3,3,3,3,8,3,2],
   [1,2,3,4,5,6,7,8,9],
   [4,6,8,7,2,3,3,3,1]]
    println("$needle in $haystack: ", onlyconsecutivein(needle, haystack))
end

needle = [3, 2, 3]
for haystack in [
    [9,3,3,3,2,3,7,8,5],
    [5,6,9,1,3,2,3,4,1],
    [1,4,3,6,7,3,8,3,2],
    [1,2,3,4,5,6,7,8,9],
    [4,6,8,7,2,3,2,3,1]]
     println("$needle in $haystack: ", onlyconsecutivein(needle, haystack))
end
