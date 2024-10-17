using Printf

let A = Point(0.0, 0.0),
    B = Point(0.0, 10.0),
    C = Point(10.0, 10.0),
    D = Point(10.0, 0.0),
    E = Point(2.5, 2.5),
    F = Point(2.5, 7.5),
    G = Point(7.5, 7.5),
    H = Point(7.5, 2.5),
    I = Point(3.0, 0.0),
    J = Point(7.0, 0.0),
    K = Point(10.0, 5.0),
    L = Point(7.0, 10.0),
    M = Point(3.0, 10.0),
    N = Point(0.0, 5.0),
    testpts = (Point(5.0, 5.0), Point(5.0, 8.0), Point(-10.0, 5.0), Point(0.0, 5.0),
        Point(10.0, 5.0), Point(8.0, 5.0), Point(10.0, 10.0))

    square = RayCastings.connect(A, B, C, D)
    square_withhole = vcat(square, RayCastings.connect(E, F, G, H))
    strange = RayCastings.connect(A, E, B, F, G, C, D, E)
    exagon = RayCastings.connect(I, J, K, L, M, N)

    println("\n# TESTING WHETHER POINTS ARE WITHIN POLYGONS")
    for poly in (square, square_withhole, strange, exagon)
        println("\nEdges: \n - ", join(poly, "\n - "))
        println("Inside/outside:")
        for p in testpts
            @printf(" - %-12s is %s\n", p, RayCastings.isinside(poly, p) ? "inside" : "outside")
        end
    end
end
