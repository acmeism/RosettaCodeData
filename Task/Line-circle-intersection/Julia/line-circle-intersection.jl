using Luxor

const centers = [Point(3, -5), Point(0, 0), Point(4, 2)]
const rads = [3, 4, 5]
const lins = [
    [Point(-10, 11), Point(10, -9)], [Point(-10, 11), Point(-11, 12)],
    [Point(3, -2), Point(7, -2)], [Point(0, -3), Point(0, 6)],
    [Point(6, 3), Point(10, 7)], [Point(7, 4), Point(11, 8)],
]

println("Center", " "^9, "Radius", " "^4, "Line P1", " "^14, "Line P2", " "^7,
    "Segment?   Intersect 1       Intersect 2")
for (cr, l, extended) in [(1, 1, true), (1, 2, false), (1, 3, false),
        (2, 4, true), (2, 4, false), (3, 5, true), (3, 6, false)]
    tup = intersectionlinecircle(lins[l][1], lins[l][2], centers[cr], rads[cr])
    v = [p for p in tup[2:end] if extended || ispointonline(p, lins[l][1], lins[l][2])]
    println(rpad(centers[cr], 17), rads[cr], " "^3, rpad(lins[l][1], 21),
        rpad(lins[l][2], 19), rpad(!extended, 8), isempty(v) ? "" :
            length(v) == 2 && tup[1] == 2 ? rpad(v[1], 18) * string(v[2]) : v[1])
end
