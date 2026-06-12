using Plots
using Polyhedra
using GLPK

lib = DefaultLibrary{Float64}(GLPK.Optimizer)

const poly1 = polyhedron(vrep([
    0 0
    0 2
    1 4
    2 2
    2 0
]), lib)

const poly2 = polyhedron(vrep([
    4 0
    4 2
    5 4
    6 2
    6 0
]), lib)

const poly3 = polyhedron(vrep([
    1 0
    1 2
    5 4
    9 2
    9 0
]), lib)

println("Polygons poly1 and poly2 intersect at ", npoints(intersect(poly1, poly2)), " points.")
println("Polygons poly1 and poly3 intersect at ", npoints(intersect(poly1, poly3)), " points.")
println("Polygons poly2 and poly3 intersect at ", npoints(intersect(poly2, poly3)), " points.")
const P1 = polyhedron(vrep([
    -1.9 -1.7
    -1.8  0.5
     1.7  0.7
     1.9 -0.3
     0.9 -1.1
]), lib)

const P2 = polyhedron(vrep([
   -2.5 -1.1
   -0.8  0.8
    0.1  0.9
    1.8 -1.2
    1.3  0.1
]), lib)

Pint = intersect(P1, P2)
println("Polygons P1 and P2 intersect at ", npoints(Pint), " points.")

plot(P1, color="blue", alpha=0.2)
plot!(P2, color="red", alpha=0.2)
plot!(Pint, color="yellow", alpha=0.6)
