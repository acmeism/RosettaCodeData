function formatdf(a::AbstractVector)
    i = 0
    s = "    "
    for c in a
        s *= @sprintf "%6s" c
        i += 1
        i %= 8
        if i == 0
            s *= "\n    "
        end
    end
    return s
end

const cnum = 20
const d = [COLORS[rand(1:3)] for i in 1:cnum]
while d == dutchsort(d)
    d .= [COLORS[rand(1:3)] for i in 1:cnum]
end

println("The original list is:")
println(formatdf(d))

print("Sorting with dutchsort, after")
@time e = dutchsort(d)
println(formatdf(e))

print("Sorting conventionally, after")
@time e = sort(d, by = x -> findfirst(==(x), COLORS))
println(formatdf(e))
