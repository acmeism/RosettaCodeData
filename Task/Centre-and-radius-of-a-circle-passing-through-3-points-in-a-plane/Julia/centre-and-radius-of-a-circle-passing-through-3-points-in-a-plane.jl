function findcircle(p1, p2, p3)
    a, b = p1
    c, d = p2
    e, f = p3
    a2b2 = a * a + b * b
    ae = a - e
    db = d - b
    c2d2 = c * c + d * d
    bf = b - f
    ec = e - c
    e2f2 = e * e + f * f
    ca = c - a
    fd = f - d
    cx = 0.5 * (a2b2 * fd + c2d2 * bf + e2f2 * db) / (a * fd + c * bf + e * db)
    cy = 0.5 * (a2b2 * ec + c2d2 * ae + e2f2 * ca) / (b * ec + d * ae + f * ca)
    # any one of these should do / be nearly identical:
    r123 = [(cx-a)^2 + (cy-b)^2, (cx-c)^2 + (cy-d)^2, (cx-e)^2 + (cy-f)^2]
    @assert maximum(r123) - minimum(r123) < 1e-12
    r = sqrt(sum(r123) / length(r123))
    return (cx, cy), r
end

ctr, r = findcircle((22.83, 2.07), (14.39, 30.24), (33.65, 17.31))
println("Centre = $ctr, radius = $r")
