function parselinear(s)
    ab, c = strip.(split(s, "="))
    a, by = strip.(split(ab, "x"))
    b = replace(by, r"[\sy]" => "")
    b[end] in "-+" && (b *= "1")
    b = replace(b, "--" => "")
    return map(x -> parse(Float64, x == "" ? "1" : x), [a, b, c])
end

function solvetwolinear(s1, s2)
    a1, b1, c1 = parselinear(s1)
    a2, b2, c2 = parselinear(s2)
    x = (b2 * c1 - b1 * c2) / (b2 * a1 - b1 * a2)
    y = (a1 * x - c1 ) / -b1
    return x, y
end

@show solvetwolinear("3x + y = -1", "2x - 3y = -19")  # solvetwolinear("3x + y = -1", "2x - 3y = -19") = (-2.0, 5.0)
