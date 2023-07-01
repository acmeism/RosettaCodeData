using Printf

luhntest(x) = luhntest(parse(Int, x))

function checkISIN(inum::AbstractString)
    if length(inum) != 12 || !all(isalpha, inum[1:2]) return false end
    return parse.(Int, collect(inum), 36) |> join |> luhntest
end

for inum in ["US0378331005", "US0373831005", "U50378331005",
    "US03378331005", "AU0000XVGZA3", "AU0000VXGZA3", "FR0000988040"]
    @printf("%-15s %5s\n", inum, ifelse(checkISIN(inum), "pass", "fail"))
end
