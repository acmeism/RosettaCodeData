constant names = {"North","North by east","North-northeast","Northeast by north",
    "Northeast","Northeast by east","East-northeast","East by north","East",
    "East by south","East-southeast","Southeast by east","Southeast","Southeast by south",
    "South-southeast","South by east","South","South by west","South-southwest",
    "Southwest by south","Southwest","Southwest by west","West-southwest",
    "West by south","West","West by north","West-northwest","Northwest by west",
    "Northwest","Northwest by north","North-northwest","North by west"}

function deg2ind(atom degree)
    return remainder(floor(degree*32/360+.5),32)+1
end function

sequence degrees
degrees = {}
for i = 0 to 32 do
    degrees &= i*11.25 + 5.62*(remainder(i+1,3)-1)
end for

integer j
for i = 1 to length(degrees) do
    j = deg2ind(degrees[i])
    printf(1, "%6.2f  %2d  %-22s\n", {degrees[i], j, names[j]})
end for
