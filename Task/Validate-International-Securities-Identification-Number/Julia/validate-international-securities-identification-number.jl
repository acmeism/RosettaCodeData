using Printf

luhntest(x::Integer) = (sum(digits(x)[1:2:end]) + sum(map(x -> sum(digits(x)), 2 * digits(x)[2:2:end]))) % 10 == 0
luhntest(x::AbstractString) = luhntest(parse(Int, x))

function checkISIN(inum::AbstractString)
    length(inum) == 12 && all(isletter, inum[1:2]) || return false
    return parse.(Int, collect(inum), base = 36) |> join |> luhntest
end

for inum in ["US0378331005", "US0373831005", "U50378331005",
    "US03378331005", "AU0000XVGZA3", "AU0000VXGZA3", "FR0000988040"]
    @printf("%-15s %5s\n", inum, ifelse(checkISIN(inum), "pass", "fail"))
end
